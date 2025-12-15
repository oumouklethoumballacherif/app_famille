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

    // Sort children by sibling rank
    for (final children in _familyTree.values) {
      children.sort((a, b) => a.siblingRank.compareTo(b.siblingRank));
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

  /// Add a new member
  Future<String?> addMember(FamilyMember member) async {
    try {
      _error = null;
      final id = await _databaseService.addMember(member);

      // Update parent's children list if applicable
      if (member.fatherId != null) {
        await _databaseService.addChildToParent(member.fatherId!, id);
      }
      if (member.motherId != null) {
        await _databaseService.addChildToParent(member.motherId!, id);
      }

      // Update tree member count
      await _databaseService.updateTreeMemberCount(member.treeId);

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
      await _databaseService.updateMember(member);
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
