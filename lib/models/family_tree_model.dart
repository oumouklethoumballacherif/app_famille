import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a family tree
class FamilyTree {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final int memberCount;

  FamilyTree({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.memberCount = 0,
  });

  /// Create FamilyTree from Firestore document
  factory FamilyTree.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyTree(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      memberCount: data['memberCount'] ?? 0,
    );
  }

  /// Convert FamilyTree to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'memberCount': memberCount,
    };
  }

  /// Create a copy with updated fields
  FamilyTree copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    int? memberCount,
  }) {
    return FamilyTree(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}
