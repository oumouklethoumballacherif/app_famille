import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/family_member_model.dart';
import '../../providers/family_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tree_provider.dart';
import '../../widgets/member_card.dart';
import 'branch_screen.dart';

import 'member_detail_screen.dart';
import '../admin/add_member_screen.dart';
import '../../l10n/app_localizations.dart';

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
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.familyTreeTitle),
        ),
        body: Center(child: Text(AppLocalizations.of(context)!.noTreeSelected)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC), // Snow white/ very light grey
      appBar: AppBar(
        title: Text(
          selectedTree.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              familyProvider.loadMembersForTree(selectedTree.id);
            },
            tooltip: AppLocalizations.of(context)!.resetTooltip,
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
              label: Text(AppLocalizations.of(context)!.addMemberButton),
              heroTag: 'add_member_fab',
              backgroundColor: AppTheme.primaryColor,
              elevation: 4,
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
              AppLocalizations.of(context)!.noMembersInTree,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              canEdit
                  ? AppLocalizations.of(context)!.addFirstMember
                  : AppLocalizations.of(context)!.noMembersAdmin,
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
                label: Text(AppLocalizations.of(context)!.addFirstMemberButton),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTree(BuildContext context, FamilyProvider familyProvider) {
    final rootMembers = familyProvider.rootMembers;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.touch_app_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tap on a family head to explore their lineage.", // Hardcoded fallback or use l10n
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Root Members List
          if (rootMembers.isEmpty)
            Center(child: Text("No family roots found."))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rootMembers.length,
              itemBuilder: (context, index) {
                final root = rootMembers[index];
                return MemberCard(
                  member: root,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BranchScreen(member: root),
                      ),
                    );
                  },
                );
              },
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
