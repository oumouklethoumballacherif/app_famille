import 'dart:async';
import 'package:flutter/material.dart';
import '../models/family_member_model.dart';
import '../services/database_service.dart';

/// Provider for managing family tree state
class FamilyProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<FamilyMember> _members = [];
  Map<String, List<FamilyMember>> _familyTree = {};
  FamilyMember? _selectedMember;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  List<FamilyMember> _searchResults = [];
  StreamSubscription<List<FamilyMember>>? _membersSubscription;
  String? _currentTreeId;

  // Getters
  List<FamilyMember> get members => _members;
  Map<String, List<FamilyMember>> get familyTree => _familyTree;
  FamilyMember? get selectedMember => _selectedMember;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  List<FamilyMember> get searchResults => _searchResults;
  String? get currentTreeId => _currentTreeId;

  /// Get root members (ancestors at the top of the tree)
  List<FamilyMember> get rootMembers => _familyTree['root'] ?? [];

  /// Load members for a specific tree
  Future<void> loadMembersForTree(String treeId) async {
    _currentTreeId = treeId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Cancel existing subscription
    await _membersSubscription?.cancel();

    // Subscribe to members of this tree
    _membersSubscription = _databaseService
        .membersStream(treeId: treeId)
        .listen(
          (members) {
            _members = members;
            _buildTree();
            _isLoading = false;

            // Auto-sync member count
            _databaseService.updateTreeMemberCountValue(treeId, members.length);

            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// Build family tree structure from flat list
  void _buildTree() {
    _familyTree = {};
    for (final member in _members) {
      final parentKey = member.fatherId ?? 'root';
      _familyTree.putIfAbsent(parentKey, () => []);
      _familyTree[parentKey]!.add(member);
    }

    // Sort children by sibling rank, then by birth date
    for (final children in _familyTree.values) {
      children.sort((a, b) {
        final rankCompare = a.siblingRank.compareTo(b.siblingRank);
        if (rankCompare != 0) return rankCompare;
        return a.birthDate.compareTo(b.birthDate);
      });
    }
  }

  /// Get children of a member
  List<FamilyMember> getChildren(String memberId) {
    return _familyTree[memberId] ?? [];
  }

  /// Get member by ID
  FamilyMember? getMemberById(String id) {
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Select a member for detailed view
  void selectMember(FamilyMember? member) {
    _selectedMember = member;
    notifyListeners();
  }

  /// Search members
  Future<void> search(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = await _databaseService.searchMembers(query);
    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  /// Recalculate sibling ranks for all members in the current tree
  Future<void> recalculateAllSiblingRanks() async {
    if (_currentTreeId == null) return;

    try {
      // Get all members
      final allMembers = await _databaseService.getAllMembers(
        treeId: _currentTreeId,
      );

      // Group members by father
      final Map<String?, List<FamilyMember>> membersByFather = {};
      for (final member in allMembers) {
        final fatherKey = member.fatherId ?? 'root';
        membersByFather.putIfAbsent(fatherKey, () => []);
        membersByFather[fatherKey]!.add(member);
      }

      // Update ranks for each family group
      for (final entry in membersByFather.entries) {
        final members = entry.value;

        // Sort by birth date
        members.sort((a, b) => a.birthDate.compareTo(b.birthDate));

        // Update each member's rank
        for (int i = 0; i < members.length; i++) {
          final member = members[i];
          final newRank = i + 1;

          // Only update if rank changed
          if (member.siblingRank != newRank) {
            await _databaseService.updateMember(
              member.copyWith(siblingRank: newRank),
            );
          }
        }
      }

      print('✅ تم إعادة حساب ترتيب جميع الأعضاء');
    } catch (e) {
      print('❌ خطأ في إعادة الحساب: $e');
    }
  }

  /// Calculate sibling rank based on birth date among siblings
  Future<int> _calculateSiblingRank(FamilyMember member) async {
    // Get all siblings (same father, same tree)
    final siblings = await _databaseService.getAllMembers(
      treeId: member.treeId,
    );

    // Filter to get only siblings with same father
    final sameFatherSiblings = siblings
        .where(
          (s) =>
              s.fatherId == member.fatherId &&
              s.id != member.id, // Exclude the member itself if updating
        )
        .toList();

    // Add the current member to the list for comparison
    sameFatherSiblings.add(member);

    // Sort by birth date (oldest first)
    sameFatherSiblings.sort((a, b) => a.birthDate.compareTo(b.birthDate));

    // Find the position (1-indexed)
    final rank =
        sameFatherSiblings.indexWhere(
          (s) =>
              s.id == member.id ||
              (s.firstName == member.firstName &&
                  s.birthDate == member.birthDate),
        ) +
        1;

    return rank > 0 ? rank : 1;
  }

  /// Update sibling ranks for all siblings of a given father
  Future<void> _updateAllSiblingRanks(String? fatherId, String treeId) async {
    if (fatherId == null) return;

    // Get all siblings
    final siblings = await _databaseService.getAllMembers(treeId: treeId);
    final sameFatherSiblings = siblings
        .where((s) => s.fatherId == fatherId)
        .toList();

    // Sort by birth date
    sameFatherSiblings.sort((a, b) => a.birthDate.compareTo(b.birthDate));

    // Update each sibling's rank
    for (int i = 0; i < sameFatherSiblings.length; i++) {
      final sibling = sameFatherSiblings[i];
      final newRank = i + 1;

      // Only update if rank changed
      if (sibling.siblingRank != newRank) {
        await _databaseService.updateMember(
          sibling.copyWith(siblingRank: newRank),
        );
      }
    }
  }

  /// Add a new member
  Future<String?> addMember(FamilyMember member) async {
    try {
      _error = null;

      // Calculate sibling rank based on birth date
      final siblingRank = await _calculateSiblingRank(member);
      final memberWithRank = member.copyWith(siblingRank: siblingRank);

      final id = await _databaseService.addMember(memberWithRank);

      // Update parent's children list if applicable
      if (memberWithRank.fatherId != null) {
        await _databaseService.addChildToParent(memberWithRank.fatherId!, id);
      }
      if (memberWithRank.motherId != null) {
        await _databaseService.addChildToParent(memberWithRank.motherId!, id);
      }

      // Update all sibling ranks to ensure consistency
      await _updateAllSiblingRanks(
        memberWithRank.fatherId,
        memberWithRank.treeId,
      );

      // Update tree member count
      await _databaseService.updateTreeMemberCount(memberWithRank.treeId);

      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update a member
  Future<bool> updateMember(FamilyMember member) async {
    try {
      _error = null;

      // Get the old member to check if father or birthDate changed
      final oldMember = await _databaseService.getMember(member.id);

      // Recalculate sibling rank if birth date or father changed
      if (oldMember != null &&
          (oldMember.birthDate != member.birthDate ||
              oldMember.fatherId != member.fatherId)) {
        final siblingRank = await _calculateSiblingRank(member);
        final memberWithRank = member.copyWith(siblingRank: siblingRank);
        await _databaseService.updateMember(memberWithRank);

        // Update all sibling ranks for both old and new father
        await _updateAllSiblingRanks(oldMember.fatherId, member.treeId);
        if (oldMember.fatherId != member.fatherId) {
          await _updateAllSiblingRanks(member.fatherId, member.treeId);
        }
      } else {
        await _databaseService.updateMember(member);
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete a member
  Future<bool> deleteMember(String memberId) async {
    try {
      _error = null;
      // Fetch member to get treeId before deletion (fetch from DB to be safe)
      final member = await _databaseService.getMember(memberId);
      final treeId = member?.treeId;

      await _databaseService.deleteMember(memberId);

      // Update tree member count
      if (treeId != null && treeId.isNotEmpty) {
        await _databaseService.updateTreeMemberCount(treeId);
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get statistics
  Map<String, int> getStatistics() {
    return {
      'total': _members.length,
      'male': _members.where((m) => m.gender == Gender.male).length,
      'female': _members.where((m) => m.gender == Gender.female).length,
      'alive': _members.where((m) => m.status == VitalStatus.alive).length,
      'deceased': _members
          .where((m) => m.status == VitalStatus.deceased)
          .length,
    };
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _membersSubscription?.cancel();
    super.dispose();
  }
}
