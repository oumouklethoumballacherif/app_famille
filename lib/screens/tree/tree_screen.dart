import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/family_member_model.dart';
import '../../providers/family_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tree_provider.dart';
import '../../widgets/tree_node_widget.dart';
import 'member_detail_screen.dart';
import '../admin/add_member_screen.dart';

/// Interactive Family Tree Screen
class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Load members for the selected tree when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final treeProvider = context.read<TreeProvider>();
      final familyProvider = context.read<FamilyProvider>();
      if (treeProvider.selectedTree != null) {
        familyProvider.loadMembersForTree(treeProvider.selectedTree!.id);
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final authProvider = context.watch<AuthProvider>();
    final treeProvider = context.watch<TreeProvider>();
    final canEdit = authProvider.canEditMembers;
    final selectedTree = treeProvider.selectedTree;

    if (selectedTree == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Arbre Familial')),
        body: const Center(child: Text('Aucun arbre sélectionné')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTree.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _transformationController.value = Matrix4.identity();
              familyProvider.loadMembersForTree(selectedTree.id);
            },
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: familyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : familyProvider.members.isEmpty
          ? _buildEmptyState(context, canEdit, selectedTree.id)
          : _buildTree(context, familyProvider),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMemberScreen(treeId: selectedTree.id),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Ajouter'),
              heroTag: 'add_member_fab',
              backgroundColor: AppTheme.primaryColor,
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, bool canEdit, String treeId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 100,
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun membre dans l\'arbre',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              canEdit
                  ? 'Commencez par ajouter le premier membre de la famille.'
                  : 'L\'administrateur n\'a pas encore ajouté de membres.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (canEdit) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddMemberScreen(treeId: treeId),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter le premier membre'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTree(BuildContext context, FamilyProvider familyProvider) {
    final rootMembers = familyProvider.rootMembers;

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.3,
      maxScale: 3.0,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pincez pour zoomer • Faites glisser pour naviguer',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Tree
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rootMembers.map((member) {
                    return _buildMemberBranch(context, member, familyProvider);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberBranch(
    BuildContext context,
    FamilyMember member,
    FamilyProvider familyProvider,
  ) {
    final children = familyProvider.getChildren(member.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Member node
          GestureDetector(
            onTap: () => _showMemberDetail(context, member),
            child: TreeNodeWidget(member: member),
          ),

          // Connection line to children
          if (children.isNotEmpty) ...[
            Container(
              width: 2,
              height: 24,
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            Container(
              height: 2,
              width: children.length * 150.0,
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map((child) {
                return _buildMemberBranch(context, child, familyProvider);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showMemberDetail(BuildContext context, FamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemberDetailScreen(member: member)),
    );
  }
}
