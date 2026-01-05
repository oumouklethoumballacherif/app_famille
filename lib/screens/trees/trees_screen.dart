import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/family_tree_model.dart';
import '../../providers/tree_provider.dart';
import '../../providers/auth_provider.dart';
import 'create_tree_screen.dart';
import '../tree/tree_screen.dart';
import '../../l10n/app_localizations.dart';

/// Screen displaying list of family trees
class TreesScreen extends StatefulWidget {
  const TreesScreen({super.key});

  @override
  State<TreesScreen> createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TreeProvider>().loadTrees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myFamilyTrees),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TreeProvider>().loadTrees(),
          ),
        ],
      ),
      body: Consumer<TreeProvider>(
        builder: (context, treeProvider, child) {
          if (treeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (treeProvider.trees.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => treeProvider.loadTrees(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: treeProvider.trees.length,
              itemBuilder: (context, index) {
                final tree = treeProvider.trees[index];
                return _buildTreeCard(context, tree);
              },
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.canEditMembers) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _navigateToCreateTree(context),
            icon: const Icon(Icons.add),
            heroTag: 'new_tree_fab',
            label: Text(AppLocalizations.of(context)!.newTree),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 100,
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noFamilyTree,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.createFirstTree,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreateTree(context),
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.createTreeButton),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeCard(BuildContext context, FamilyTree tree) {
    final authProvider = context.read<AuthProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToTree(context, tree),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Tree Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_tree,
                  size: 32,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              // Tree Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tree.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tree.description != null &&
                        tree.description!.isNotEmpty)
                      Text(
                        tree.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tree.memberCount} ${AppLocalizations.of(context)!.membersCount}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              if (authProvider.canEditMembers)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEditTree(context, tree);
                    } else if (value == 'delete') {
                      _confirmDeleteTree(context, tree);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.editAction),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: AppTheme.errorColor),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.deleteAction,
                            style: const TextStyle(color: AppTheme.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToCreateTree(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTreeScreen()),
    );
    if (mounted) {
      context.read<TreeProvider>().loadTrees();
    }
  }

  Future<void> _navigateToEditTree(
    BuildContext context,
    FamilyTree tree,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTreeScreen(tree: tree)),
    );
    if (mounted) {
      context.read<TreeProvider>().loadTrees();
    }
  }

  Future<void> _navigateToTree(BuildContext context, FamilyTree tree) async {
    context.read<TreeProvider>().selectTree(tree);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TreeScreen()),
    );
    if (mounted) {
      context.read<TreeProvider>().loadTrees();
    }
  }

  Future<void> _confirmDeleteTree(BuildContext context, FamilyTree tree) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteTreeTitle),
        content: Text(
          AppLocalizations.of(context)!.deleteTreeConfirmation(tree.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text(AppLocalizations.of(context)!.deleteAction),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<TreeProvider>().deleteTree(tree.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? AppLocalizations.of(context)!.treeDeleted
                  : AppLocalizations.of(context)!.deleteError,
            ),
            backgroundColor: success
                ? AppTheme.successColor
                : AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
