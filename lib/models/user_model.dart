import 'package:cloud_firestore/cloud_firestore.dart';

/// User roles in the family tree application
enum UserRole {
  admin, // Full access - can manage everything
  moderator, // Can add/edit members with admin permission
  member, // Read-only access
}

/// Extension to convert UserRole to/from string
extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.moderator:
        return 'moderator';
      case UserRole.member:
        return 'member';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      default:
        return UserRole.member;
    }
  }
}

/// User model representing an authenticated user
class AppUser {
  final String uid;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isApproved;
  final String?
  linkedMemberId; // Link to their family member profile if applicable
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  AppUser({
    required this.uid,
    required this.email,
    this.phone,
    this.role = UserRole.member,
    this.isApproved = false,
    this.linkedMemberId,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Create AppUser from Firestore document
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      phone: data['phone'],
      role: UserRoleExtension.fromString(data['role'] ?? 'member'),
      isApproved: data['isApproved'] ?? false,
      linkedMemberId: data['linkedMemberId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert AppUser to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'phone': phone,
      'role': role.value,
      'isApproved': isApproved,
      'linkedMemberId': linkedMemberId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null
          ? Timestamp.fromDate(lastLoginAt!)
          : null,
    };
  }

  /// Create a copy with updated fields
  AppUser copyWith({
    String? uid,
    String? email,
    String? phone,
    UserRole? role,
    bool? isApproved,
    String? linkedMemberId,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isApproved: isApproved ?? this.isApproved,
      linkedMemberId: linkedMemberId ?? this.linkedMemberId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Check if user has admin privileges
  bool get isAdmin => role == UserRole.admin;

  /// Check if user can edit members (admin or moderator)
  bool get canEditMembers =>
      role == UserRole.admin || role == UserRole.moderator;

  /// Check if user can create events (admin or moderator)
  bool get canCreateEvents =>
      role == UserRole.admin || role == UserRole.moderator;

  /// Check if user can manage users (admin only)
  bool get canManageUsers => role == UserRole.admin;
}
