import 'package:flutter/material.dart';
import '../models/family_tree_model.dart';
import '../services/database_service.dart';

/// Provider for managing family tree state
class TreeProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<FamilyTree> _trees = [];
  FamilyTree? _selectedTree;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FamilyTree> get trees => _trees;
  FamilyTree? get selectedTree => _selectedTree;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSelectedTree => _selectedTree != null;

  /// Load all trees
  Future<void> loadTrees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trees = await _databaseService.getAllTrees();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a tree
  void selectTree(FamilyTree? tree) {
    _selectedTree = tree;
    notifyListeners();
  }

  /// Select tree by ID
  Future<void> selectTreeById(String treeId) async {
    try {
      final tree = await _databaseService.getTree(treeId);
      _selectedTree = tree;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Add a new tree
  Future<String?> addTree({
    required String name,
    String? description,
    required String createdBy,
  }) async {
    try {
      _error = null;
      final tree = FamilyTree(
        id: '',
        name: name,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: createdBy,
        memberCount: 0,
      );

      final treeId = await _databaseService.addTree(tree);
      await loadTrees();

      // Auto-select the new tree
      _selectedTree = _trees.firstWhere((t) => t.id == treeId);
      notifyListeners();

      return treeId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update an existing tree
  Future<bool> updateTree({
    required String treeId,
    required String name,
    String? description,
  }) async {
    try {
      _error = null;
      final existingTree = await _databaseService.getTree(treeId);
      if (existingTree == null) {
        _error = 'Arbre non trouvé';
        notifyListeners();
        return false;
      }

      final updatedTree = existingTree.copyWith(
        name: name,
        description: description,
        updatedAt: DateTime.now(),
      );

      await _databaseService.updateTree(updatedTree);
      await loadTrees();

      // Update selected tree if it was the one updated
      if (_selectedTree?.id == treeId) {
        _selectedTree = _trees.firstWhere((t) => t.id == treeId);
      }
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete a tree and all its members
  Future<bool> deleteTree(String treeId) async {
    try {
      _error = null;
      await _databaseService.deleteTree(treeId);

      // Clear selection if the deleted tree was selected
      if (_selectedTree?.id == treeId) {
        _selectedTree = null;
      }

      await loadTrees();
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
}
