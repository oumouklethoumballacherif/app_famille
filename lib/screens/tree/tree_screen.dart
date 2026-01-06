import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/family_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tree_provider.dart';
import '../../widgets/member_card.dart';
import '../../widgets/member_card_widget.dart';
import '../../widgets/family_stats_widget.dart';
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
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<FamilyProvider>().search(query);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<FamilyProvider>().clearSearch();
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
            icon: const Icon(Icons.sync),
            onPressed: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              await familyProvider.recalculateAllSiblingRanks();

              if (mounted) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.treeUpdated),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            tooltip: 'إعادة حساب الترتيب',
          ),
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
          : Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  color: Colors.white,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: familyProvider.searchQuery.isEmpty
                      ? _buildTree(context, familyProvider)
                      : _buildSearchResults(context, familyProvider),
                ),
              ],
            ),
      floatingActionButton: canEdit && familyProvider.searchQuery.isEmpty
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

  Widget _buildSearchResults(
    BuildContext context,
    FamilyProvider familyProvider,
  ) {
    final results = familyProvider.searchResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noSearchResults,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final member = results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: MemberCardWidget(
            member: member,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailScreen(member: member),
                ),
              );
            },
            highlightQuery: familyProvider.searchQuery,
          ),
        );
      },
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
    final stats = familyProvider.getStatistics();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FamilyStatsWidget(stats: stats),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: MemberCard(
                    member: root,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BranchScreen(member: root),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
