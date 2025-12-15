import 'package:cloud_firestore/cloud_firestore.dart';

/// Gender enumeration
enum Gender { male, female }

/// Extension for Gender enum
extension GenderExtension on Gender {
  String get value => this == Gender.male ? 'male' : 'female';

  String get displayName => this == Gender.male ? 'Homme' : 'Femme';

  String get displayNameAr => this == Gender.male ? 'ذكر' : 'أنثى';

  static Gender fromString(String value) {
    return value.toLowerCase() == 'male' ? Gender.male : Gender.female;
  }
}

/// Vital status enumeration
enum VitalStatus { alive, deceased }

/// Extension for VitalStatus enum
extension VitalStatusExtension on VitalStatus {
  String get value => this == VitalStatus.alive ? 'alive' : 'deceased';

  String get displayName => this == VitalStatus.alive ? 'Vivant' : 'Décédé';

  String get displayNameAr => this == VitalStatus.alive ? 'حي' : 'متوفى';

  /// Arabic phrase for deceased members
  String get deceasedPhrase => 'رحمه الله';

  static VitalStatus fromString(String value) {
    return value.toLowerCase() == 'alive'
        ? VitalStatus.alive
        : VitalStatus.deceased;
  }
}

/// Family member model representing a person in the family tree
class FamilyMember {
  final String id;
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final DateTime birthDate;
  final String birthPlace;
  final Gender gender;
  final String? photoUrl;
  final int siblingRank; // Position among siblings (1st, 2nd, 3rd, etc.)
  final VitalStatus status;
  final DateTime? deathDate;
  final String? fatherId; // Reference to father's ID
  final String? motherId; // Reference to mother's ID
  final List<String> childrenIds; // List of children IDs
  final String? spouseId; // Reference to spouse's ID
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy; // User ID who created this record
  final String treeId; // Reference to the family tree

  FamilyMember({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.birthDate,
    required this.birthPlace,
    required this.gender,
    this.photoUrl,
    this.siblingRank = 1,
    this.status = VitalStatus.alive,
    this.deathDate,
    this.fatherId,
    this.motherId,
    this.childrenIds = const [],
    this.spouseId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.treeId,
  });

  /// Get full name in the format: FirstName FatherName GrandfatherName
  String get fullName => '$firstName $fatherName $grandfatherName';

  /// Get display name with deceased phrase if applicable
  String get displayName {
    if (status == VitalStatus.deceased) {
      return '$fullName (${status.deceasedPhrase})';
    }
    return fullName;
  }

  /// Check if this member has a father in the tree
  bool get hasFather => fatherId != null && fatherId!.isNotEmpty;

  /// Check if this member has a mother in the tree
  bool get hasMother => motherId != null && motherId!.isNotEmpty;

  /// Check if this member has children
  bool get hasChildren => childrenIds.isNotEmpty;

  /// Get age (or age at death)
  int get age {
    final endDate = deathDate ?? DateTime.now();
    int age = endDate.year - birthDate.year;
    if (endDate.month < birthDate.month ||
        (endDate.month == birthDate.month && endDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Create FamilyMember from Firestore document
  factory FamilyMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyMember(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      fatherName: data['fatherName'] ?? '',
      grandfatherName: data['grandfatherName'] ?? '',
      birthDate:
          (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime(1900, 1, 1),
      birthPlace: data['birthPlace'] ?? '',
      gender: GenderExtension.fromString(data['gender'] ?? 'male'),
      photoUrl: data['photoUrl'],
      siblingRank: data['siblingRank'] ?? 1,
      status: VitalStatusExtension.fromString(data['status'] ?? 'alive'),
      deathDate: (data['deathDate'] as Timestamp?)?.toDate(),
      fatherId: data['fatherId'],
      motherId: data['motherId'],
      childrenIds: List<String>.from(data['childrenIds'] ?? []),
      spouseId: data['spouseId'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      treeId: data['treeId'] ?? '',
    );
  }

  /// Convert FamilyMember to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'fatherName': fatherName,
      'grandfatherName': grandfatherName,
      'birthDate': Timestamp.fromDate(birthDate),
      'birthPlace': birthPlace,
      'gender': gender.value,
      'photoUrl': photoUrl,
      'siblingRank': siblingRank,
      'status': status.value,
      'deathDate': deathDate != null ? Timestamp.fromDate(deathDate!) : null,
      'fatherId': fatherId,
      'motherId': motherId,
      'childrenIds': childrenIds,
      'spouseId': spouseId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'treeId': treeId,
    };
  }

  /// Create a copy with updated fields
  FamilyMember copyWith({
    String? id,
    String? firstName,
    String? fatherName,
    String? grandfatherName,
    DateTime? birthDate,
    String? birthPlace,
    Gender? gender,
    String? photoUrl,
    int? siblingRank,
    VitalStatus? status,
    DateTime? deathDate,
    String? fatherId,
    String? motherId,
    List<String>? childrenIds,
    String? spouseId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? treeId,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      fatherName: fatherName ?? this.fatherName,
      grandfatherName: grandfatherName ?? this.grandfatherName,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      siblingRank: siblingRank ?? this.siblingRank,
      status: status ?? this.status,
      deathDate: deathDate ?? this.deathDate,
      fatherId: fatherId ?? this.fatherId,
      motherId: motherId ?? this.motherId,
      childrenIds: childrenIds ?? this.childrenIds,
      spouseId: spouseId ?? this.spouseId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      treeId: treeId ?? this.treeId,
    );
  }
}
