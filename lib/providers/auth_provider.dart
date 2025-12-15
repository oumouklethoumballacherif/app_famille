import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _currentUser;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AppUser?>? _userSubscription;

  AuthProvider() {
    _init();
  }

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isApproved => _currentUser?.isApproved ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get canEditMembers => _currentUser?.canEditMembers ?? false;
  bool get canCreateEvents => _currentUser?.canCreateEvents ?? false;

  /// Initialize auth state listener
  void _init() {
    _authSubscription = _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        // Subscribe to user document changes
        _userSubscription?.cancel();
        _userSubscription =
            _authService.appUserStream(firebaseUser.uid).listen((appUser) {
          _currentUser = appUser;
          _isLoading = false;
          notifyListeners();
        });
      } else {
        _currentUser = null;
        _isLoading = false;
        _userSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signIn(
        email: email,
        password: password,
      );

      _isLoading = false;

      if (user == null) {
        _error = 'Erreur de connexion';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signUp(
        email: email,
        password: password,
        phone: phone,
      );

      _isLoading = false;

      if (user == null) {
        _error = 'Erreur d\'inscription';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  /// Send password reset email
  Future<bool> sendPasswordReset(String email) async {
    try {
      _error = null;
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ============= ADMIN FUNCTIONS =============

  /// Get pending users (Admin only)
  Future<List<AppUser>> getPendingUsers() async {
    return await _authService.getPendingUsers();
  }

  /// Approve a user (Admin only)
  Future<void> approveUser(String userId) async {
    await _authService.approveUser(userId);
  }

  /// Reject a user (Admin only)
  Future<void> rejectUser(String userId) async {
    await _authService.rejectUser(userId);
  }

  /// Set user role (Admin only)
  Future<void> setUserRole(String userId, UserRole role) async {
    await _authService.setUserRole(userId, role);
  }

  /// Get all approved users
  Future<List<AppUser>> getAllApprovedUsers() async {
    return await _authService.getAllApprovedUsers();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.dispose();
  }
}
