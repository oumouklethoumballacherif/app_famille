import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_member_model.dart';
import '../models/family_tree_model.dart';
import '../models/event_model.dart';
import '../config/constants.dart';

/// Service for handling Firestore database operations
class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============= FAMILY TREES =============

  /// Get all family trees
  Future<List<FamilyTree>> getAllTrees() async {
    final snapshot = await _firestore
        .collection(AppConstants.treesCollection)
        .orderBy('name')
        .get();

    return snapshot.docs.map((doc) => FamilyTree.fromFirestore(doc)).toList();
  }

  /// Stream of all family trees
  Stream<List<FamilyTree>> treesStream() {
    return _firestore
        .collection(AppConstants.treesCollection)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FamilyTree.fromFirestore(doc))
              .toList(),
        );
  }

  /// Get a single tree by ID
  Future<FamilyTree?> getTree(String treeId) async {
    final doc = await _firestore
        .collection(AppConstants.treesCollection)
        .doc(treeId)
        .get();

    return doc.exists ? FamilyTree.fromFirestore(doc) : null;
  }

  /// Add a new family tree
  Future<String> addTree(FamilyTree tree) async {
    final docRef = await _firestore
        .collection(AppConstants.treesCollection)
        .add(tree.toFirestore());
    return docRef.id;
  }

  /// Update a family tree
  Future<void> updateTree(FamilyTree tree) async {
    await _firestore
        .collection(AppConstants.treesCollection)
        .doc(tree.id)
        .update(tree.copyWith(updatedAt: DateTime.now()).toFirestore());
  }

  /// Delete a family tree and all its members
  Future<void> deleteTree(String treeId) async {
    // First delete all members belonging to this tree
    final membersSnapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .where('treeId', isEqualTo: treeId)
        .get();

    final batch = _firestore.batch();
    for (final doc in membersSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete the tree itself
    batch.delete(
      _firestore.collection(AppConstants.treesCollection).doc(treeId),
    );

    await batch.commit();
  }

  /// Update member count for a tree
  Future<void> updateTreeMemberCount(String treeId) async {
    final membersSnapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .where('treeId', isEqualTo: treeId)
        .get();

    await _firestore
        .collection(AppConstants.treesCollection)
        .doc(treeId)
        .update({'memberCount': membersSnapshot.docs.length});
  }

  /// Update member count with explicit value
  Future<void> updateTreeMemberCountValue(String treeId, int count) async {
    await _firestore
        .collection(AppConstants.treesCollection)
        .doc(treeId)
        .update({'memberCount': count});
  }

  // ============= FAMILY MEMBERS =============

  /// Get all family members (optionally filtered by tree)
  Future<List<FamilyMember>> getAllMembers({String? treeId}) async {
    Query query = _firestore.collection(AppConstants.membersCollection);

    if (treeId != null) {
      query = query.where('treeId', isEqualTo: treeId);
    }

    final snapshot = await query.orderBy('birthDate').get();
    return snapshot.docs
        .map((doc) => FamilyMember.fromFirestore(doc as DocumentSnapshot))
        .toList();
  }

  /// Stream of family members (optionally filtered by tree)
  Stream<List<FamilyMember>> membersStream({String? treeId}) {
    Query query = _firestore.collection(AppConstants.membersCollection);

    if (treeId != null) {
      query = query.where('treeId', isEqualTo: treeId);
    }

    return query
        .orderBy('birthDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FamilyMember.fromFirestore(doc as DocumentSnapshot))
              .toList(),
        );
  }

  /// Get a single member by ID
  Future<FamilyMember?> getMember(String memberId) async {
    final doc = await _firestore
        .collection(AppConstants.membersCollection)
        .doc(memberId)
        .get();

    return doc.exists ? FamilyMember.fromFirestore(doc) : null;
  }

  /// Stream of a single member
  Stream<FamilyMember?> memberStream(String memberId) {
    return _firestore
        .collection(AppConstants.membersCollection)
        .doc(memberId)
        .snapshots()
        .map((doc) => doc.exists ? FamilyMember.fromFirestore(doc) : null);
  }

  /// Add a new family member
  Future<String> addMember(FamilyMember member) async {
    final docRef = await _firestore
        .collection(AppConstants.membersCollection)
        .add(member.toFirestore());
    return docRef.id;
  }

  /// Update a family member
  Future<void> updateMember(FamilyMember member) async {
    await _firestore
        .collection(AppConstants.membersCollection)
        .doc(member.id)
        .update(member.copyWith(updatedAt: DateTime.now()).toFirestore());
  }

  /// Delete a family member
  Future<void> deleteMember(String memberId) async {
    await _firestore
        .collection(AppConstants.membersCollection)
        .doc(memberId)
        .delete();
  }

  /// Search members by name
  Future<List<FamilyMember>> searchMembers(String query) async {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();
    final snapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .get();

    return snapshot.docs
        .map((doc) => FamilyMember.fromFirestore(doc))
        .where(
          (member) =>
              member.firstName.toLowerCase().contains(queryLower) ||
              member.fatherName.toLowerCase().contains(queryLower) ||
              member.grandfatherName.toLowerCase().contains(queryLower),
        )
        .toList();
  }

  /// Get children of a member
  Future<List<FamilyMember>> getChildren(String parentId) async {
    final snapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .where('fatherId', isEqualTo: parentId)
        .get();

    final motherSnapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .where('motherId', isEqualTo: parentId)
        .get();

    final children = <FamilyMember>[];
    for (final doc in snapshot.docs) {
      children.add(FamilyMember.fromFirestore(doc));
    }
    for (final doc in motherSnapshot.docs) {
      final member = FamilyMember.fromFirestore(doc);
      if (!children.any((c) => c.id == member.id)) {
        children.add(member);
      }
    }

    return children;
  }

  /// Get root members (those without parents in the system)
  Future<List<FamilyMember>> getRootMembers() async {
    final snapshot = await _firestore
        .collection(AppConstants.membersCollection)
        .where('fatherId', isNull: true)
        .get();

    return snapshot.docs.map((doc) => FamilyMember.fromFirestore(doc)).toList();
  }

  /// Add child to parent's children list
  Future<void> addChildToParent(String parentId, String childId) async {
    await _firestore
        .collection(AppConstants.membersCollection)
        .doc(parentId)
        .update({
          'childrenIds': FieldValue.arrayUnion([childId]),
        });
  }

  // ============= EVENTS =============

  /// Get all events
  Future<List<FamilyEvent>> getAllEvents() async {
    final snapshot = await _firestore
        .collection(AppConstants.eventsCollection)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => FamilyEvent.fromFirestore(doc)).toList();
  }

  /// Stream of all events
  Stream<List<FamilyEvent>> eventsStream() {
    return _firestore
        .collection(AppConstants.eventsCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FamilyEvent.fromFirestore(doc))
              .toList(),
        );
  }

  /// Get upcoming events
  Future<List<FamilyEvent>> getUpcomingEvents() async {
    final snapshot = await _firestore
        .collection(AppConstants.eventsCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('date')
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => FamilyEvent.fromFirestore(doc)).toList();
  }

  /// Get a single event by ID
  Future<FamilyEvent?> getEvent(String eventId) async {
    final doc = await _firestore
        .collection(AppConstants.eventsCollection)
        .doc(eventId)
        .get();

    return doc.exists ? FamilyEvent.fromFirestore(doc) : null;
  }

  /// Add a new event
  Future<String> addEvent(FamilyEvent event) async {
    final docRef = await _firestore
        .collection(AppConstants.eventsCollection)
        .add(event.toFirestore());
    return docRef.id;
  }

  /// Update an event
  Future<void> updateEvent(FamilyEvent event) async {
    await _firestore
        .collection(AppConstants.eventsCollection)
        .doc(event.id)
        .update(event.toFirestore());
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    await _firestore
        .collection(AppConstants.eventsCollection)
        .doc(eventId)
        .delete();
  }

  /// Mark event notification as sent
  Future<void> markEventNotificationSent(String eventId) async {
    await _firestore
        .collection(AppConstants.eventsCollection)
        .doc(eventId)
        .update({'isNotificationSent': true});
  }

  // ============= TREE STRUCTURE =============

  /// Build the complete family tree structure
  Future<Map<String, List<FamilyMember>>> buildFamilyTree() async {
    final allMembers = await getAllMembers();
    final Map<String, List<FamilyMember>> tree = {};

    for (final member in allMembers) {
      // Group by father ID (or 'root' if no father)
      final parentKey = member.fatherId ?? 'root';
      tree.putIfAbsent(parentKey, () => []);
      tree[parentKey]!.add(member);
    }

    // Sort children by sibling rank
    for (final children in tree.values) {
      children.sort((a, b) => a.siblingRank.compareTo(b.siblingRank));
    }

    return tree;
  }
}
