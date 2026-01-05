import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';

/// User Management Screen for Admin
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AppUser> _pendingUsers = [];
  List<AppUser> _approvedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    _pendingUsers = await authProvider.getPendingUsers();
    _approvedUsers = await authProvider.getAllApprovedUsers();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageUsersAction),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text:
                  '${AppLocalizations.of(context)!.pendingTab} (${_pendingUsers.length})',
              icon: const Icon(Icons.hourglass_empty),
            ),
            Tab(
              text:
                  '${AppLocalizations.of(context)!.approvedTab} (${_approvedUsers.length})',
              icon: const Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildPendingList(), _buildApprovedList()],
            ),
    );
  }

  Widget _buildPendingList() {
    if (_pendingUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppTheme.successColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noPendingRequests,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingUsers.length,
        itemBuilder: (context, index) {
          final user = _pendingUsers[index];
          return _buildPendingUserCard(user);
        },
      ),
    );
  }

  Widget _buildPendingUserCard(AppUser user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.warningColor.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: AppTheme.warningColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (user.phone != null)
                        Text(
                          user.phone!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _rejectUser(user),
                  icon: const Icon(Icons.close),
                  label: Text(AppLocalizations.of(context)!.rejectAction),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: const BorderSide(color: AppTheme.errorColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _approveUser(user),
                  icon: const Icon(Icons.check),
                  label: Text(AppLocalizations.of(context)!.approveAction),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedList() {
    if (_approvedUsers.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noApprovedUsers));
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _approvedUsers.length,
        itemBuilder: (context, index) {
          final user = _approvedUsers[index];
          return _buildApprovedUserCard(user);
        },
      ),
    );
  }

  Widget _buildApprovedUserCard(AppUser user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role).withValues(alpha: 0.2),
          child: Icon(_getRoleIcon(user.role), color: _getRoleColor(user.role)),
        ),
        title: Text(user.email),
        subtitle: Text(_getRoleDisplayName(context, user.role)),
        trailing: PopupMenuButton<UserRole>(
          icon: const Icon(Icons.more_vert),
          onSelected: (role) => _changeUserRole(user, role),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: UserRole.member,
              child: Text(AppLocalizations.of(context)!.roleMember),
            ),
            PopupMenuItem(
              value: UserRole.moderator,
              child: Text(AppLocalizations.of(context)!.roleModerator),
            ),
            PopupMenuItem(
              value: UserRole.admin,
              child: Text(AppLocalizations.of(context)!.roleAdmin),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _approveUser(AppUser user) async {
    try {
      await context.read<AuthProvider>().approveUser(user.uid);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.userApprovedMessage(user.email),
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
      await _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _rejectUser(AppUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmRejectTitle),
        content: Text(
          AppLocalizations.of(context)!.confirmRejectMessage(user.email),
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
            child: Text(AppLocalizations.of(context)!.rejectAction),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      try {
        await context.read<AuthProvider>().rejectUser(user.uid);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.requestRejectedMessage),
            backgroundColor: AppTheme.warningColor,
          ),
        );
        await _loadUsers();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _changeUserRole(AppUser user, UserRole newRole) async {
    try {
      await context.read<AuthProvider>().setUserRole(user.uid, newRole);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.roleChangedMessage(
              user.email,
              _getRoleDisplayName(context, newRole),
            ),
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
      await _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.moderator:
        return Icons.shield;
      case UserRole.member:
        return Icons.person;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppTheme.accentColor;
      case UserRole.moderator:
        return AppTheme.primaryColor;
      case UserRole.member:
        return AppTheme.textSecondary;
    }
  }

  String _getRoleDisplayName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppLocalizations.of(context)!.roleAdmin;
      case UserRole.moderator:
        return AppLocalizations.of(context)!.roleModerator;
      case UserRole.member:
        return AppLocalizations.of(context)!.roleMember;
    }
  }
}
