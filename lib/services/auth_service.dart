import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/constants.dart';

/// Service for handling Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Update last login time
        await _updateLastLogin(credential.user!.uid);
        return await getAppUser(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign up with email and password
  /// New users are NOT approved by default - they need admin approval
  Future<AppUser?> signUp({
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final newUser = AppUser(
          uid: credential.user!.uid,
          email: email.trim(),
          phone: phone,
          role: UserRole.member,
          isApproved: false, // Requires admin approval
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(newUser.uid)
            .set(newUser.toFirestore());

        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Get AppUser from Firestore by UID
  Future<AppUser?> getAppUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Stream of current AppUser
  Stream<AppUser?> appUserStream(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  /// Update last login timestamp
  Future<void> _updateLastLogin(String uid) async {
    await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  /// Handle Firebase Auth exceptions with French messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'invalid-email':
        return 'L\'adresse email est invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Erreur (${e.code}): ${e.message}';
    }
  }

  // ============= ADMIN FUNCTIONS =============

  /// Get list of users pending approval (Admin only)
  Future<List<AppUser>> getPendingUsers() async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('isApproved', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
  }

  /// Approve a user (Admin only)
  Future<void> approveUser(String userId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'isApproved': true});
  }

  /// Reject/Delete a user (Admin only)
  Future<void> rejectUser(String userId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .delete();
  }

  /// Set user role (Admin only)
  Future<void> setUserRole(String userId, UserRole role) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'role': role.value});
  }

  /// Get all approved users
  Future<List<AppUser>> getAllApprovedUsers() async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('isApproved', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
  }
}
