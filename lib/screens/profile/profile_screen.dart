import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';

/// User Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final familyProvider = context.watch<FamilyProvider>();
    final currentUser = authProvider.currentUser;

    // Get linked family member if any
    final linkedMember = currentUser?.linkedMemberId != null
        ? familyProvider.getMemberById(currentUser!.linkedMemberId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context, authProvider),
            tooltip: AppLocalizations.of(context)!.logoutLabel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(
                        currentUser?.role.index == 0
                            ? Icons.admin_panel_settings
                            : currentUser?.role.index == 1
                            ? Icons.shield
                            : Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Text(
                      currentUser?.email ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          currentUser?.role,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getRoleDisplayName(context, currentUser?.role),
                        style: TextStyle(
                          color: _getRoleColor(currentUser?.role),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.accountInfoTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      Icons.email,
                      AppLocalizations.of(context)!.emailLabel,
                      currentUser?.email ?? '-',
                    ),
                    _buildInfoRow(
                      context,
                      Icons.phone,
                      AppLocalizations.of(context)!.phoneLabel,
                      currentUser?.phone ??
                          AppLocalizations.of(context)!.notProvided,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.verified_user,
                      AppLocalizations.of(context)!.statusLabel,
                      currentUser?.isApproved == true
                          ? AppLocalizations.of(context)!.statusApproved
                          : AppLocalizations.of(context)!.statusPending,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.settingsTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            size: 20,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.languageLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Consumer<LanguageProvider>(
                            builder: (context, languageProvider, child) {
                              return DropdownButton<Locale>(
                                value: languageProvider.locale,
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(
                                    value: Locale('fr', ''),
                                    child: Text('Français'),
                                  ),
                                  DropdownMenuItem(
                                    value: Locale('en', ''),
                                    child: Text('English'),
                                  ),
                                  DropdownMenuItem(
                                    value: Locale('ar', ''),
                                    child: Text('العربية'),
                                  ),
                                ],
                                onChanged: (Locale? newLocale) {
                                  if (newLocale != null) {
                                    languageProvider.changeLanguage(newLocale);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Linked Family Member
            if (linkedMember != null)
              Card(
                child: InkWell(
                  onTap: () {
                    // Navigate to member detail
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.family_restroom,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.linkedMemberTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    linkedMember.fullName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.viewFullProfile,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Permissions Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.security,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.permissionsTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildPermissionRow(
                      context,
                      AppLocalizations.of(context)!.permissionViewTree,
                      true,
                    ),
                    _buildPermissionRow(
                      context,
                      AppLocalizations.of(context)!.permissionEditMembers,
                      authProvider.canEditMembers,
                    ),
                    _buildPermissionRow(
                      context,
                      AppLocalizations.of(context)!.permissionCreateEvents,
                      authProvider.canCreateEvents,
                    ),
                    _buildPermissionRow(
                      context,
                      AppLocalizations.of(context)!.permissionManageUsers,
                      authProvider.isAdmin,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context, authProvider),
                icon: const Icon(Icons.logout),
                label: Text(AppLocalizations.of(context)!.logoutAction),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                  side: const BorderSide(color: AppTheme.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // DEBUG BUTTON
            if (!authProvider.isAdmin)
              TextButton(
                onPressed: () async {
                  await authProvider.promoteSelfToAdmin();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.promotedToAdmin,
                        ),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.devBecomeAdmin),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(
    BuildContext context,
    String permission,
    bool allowed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            allowed ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: allowed ? AppTheme.successColor : AppTheme.errorColor,
          ),
          const SizedBox(width: 12),
          Text(permission, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Color _getRoleColor(dynamic role) {
    if (role == null) return AppTheme.textSecondary;
    switch (role.index) {
      case 0:
        return AppTheme.accentColor;
      case 1:
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getRoleDisplayName(BuildContext context, dynamic role) {
    if (role == null) return AppLocalizations.of(context)!.roleMember;
    switch (role.index) {
      case 0:
        return AppLocalizations.of(context)!.roleAdmin;
      case 1:
        return AppLocalizations.of(context)!.roleModerator;
      default:
        return AppLocalizations.of(context)!.roleMember;
    }
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logoutLabel),
        content: Text(AppLocalizations.of(context)!.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text(AppLocalizations.of(context)!.logoutAction),
          ),
        ],
      ),
    );
  }
}
