import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../models/family_member_model.dart';
import '../../providers/family_provider.dart';
// import '../../providers/auth_provider.dart';

/// Member Detail Screen - Shows full profile of a family member
class MemberDetailScreen extends StatelessWidget {
  final FamilyMember member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    // final authProvider = context.watch<AuthProvider>();
    // final canEdit = authProvider.canEditMembers;

    // Get parent and children information
    final father = member.fatherId != null
        ? familyProvider.getMemberById(member.fatherId!)
        : null;
    final mother = member.motherId != null
        ? familyProvider.getMemberById(member.motherId!)
        : null;
    final children = familyProvider.getChildren(member.id);
    final spouse = member.spouseId != null
        ? familyProvider.getMemberById(member.spouseId!)
        : null;

    final genderColor = member.gender == Gender.male
        ? AppTheme.maleColor
        : AppTheme.femaleColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with photo
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: genderColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Photo or placeholder
                  if (member.photoUrl != null)
                    CachedNetworkImage(
                      imageUrl: member.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: genderColor.withValues(alpha: 0.3),
                        child: Icon(
                          member.gender == Gender.male
                              ? Icons.person
                              : Icons.person_2,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: genderColor.withValues(alpha: 0.3),
                        child: Icon(
                          member.gender == Gender.male
                              ? Icons.person
                              : Icons.person_2,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: genderColor.withValues(alpha: 0.3),
                      child: Icon(
                        member.gender == Gender.male
                            ? Icons.person
                            : Icons.person_2,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          genderColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),

                  // Deceased overlay
                  if (member.status == VitalStatus.deceased)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                ],
              ),
              title: Text(
                member.firstName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.badge,
                                color: genderColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nom Complet',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            member.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          if (member.status == VitalStatus.deceased) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.deceasedColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${member.status.displayName} - ${member.status.deceasedPhrase}',
                                style: TextStyle(
                                  color: AppTheme.deceasedColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Information Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: genderColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Informations',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Icons.cake,
                            'Date de naissance',
                            DateFormat('dd MMMM yyyy', 'fr_FR')
                                .format(member.birthDate),
                          ),
                          _buildInfoRow(
                            context,
                            Icons.location_on,
                            'Lieu de naissance',
                            member.birthPlace,
                          ),
                          _buildInfoRow(
                            context,
                            member.gender == Gender.male
                                ? Icons.male
                                : Icons.female,
                            'Sexe',
                            member.gender.displayName,
                          ),
                          _buildInfoRow(
                            context,
                            Icons.format_list_numbered,
                            'Rang dans la fratrie',
                            '${member.siblingRank}${_getOrdinalSuffix(member.siblingRank)}',
                          ),
                          _buildInfoRow(
                            context,
                            Icons.access_time,
                            'Âge',
                            '${member.age} ans',
                          ),
                          if (member.deathDate != null)
                            _buildInfoRow(
                              context,
                              Icons.event,
                              'Date de décès',
                              DateFormat('dd MMMM yyyy', 'fr_FR')
                                  .format(member.deathDate!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Family Relations Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.family_restroom,
                                color: genderColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Liens Familiaux',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          if (father != null)
                            _buildRelationRow(
                              context,
                              'Père',
                              father,
                              AppTheme.maleColor,
                            ),
                          if (mother != null)
                            _buildRelationRow(
                              context,
                              'Mère',
                              mother,
                              AppTheme.femaleColor,
                            ),
                          if (spouse != null)
                            _buildRelationRow(
                              context,
                              member.gender == Gender.male ? 'Épouse' : 'Époux',
                              spouse,
                              spouse.gender == Gender.male
                                  ? AppTheme.maleColor
                                  : AppTheme.femaleColor,
                            ),
                          if (children.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Enfants (${children.length})',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            ...children.map((child) => _buildRelationRow(
                                  context,
                                  child.gender == Gender.male
                                      ? 'Fils'
                                      : 'Fille',
                                  child,
                                  child.gender == Gender.male
                                      ? AppTheme.maleColor
                                      : AppTheme.femaleColor,
                                )),
                          ],
                          if (father == null &&
                              mother == null &&
                              spouse == null &&
                              children.isEmpty)
                            const Text(
                              'Aucun lien familial enregistré',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Notes if any
                  if (member.notes != null && member.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.notes,
                                  color: genderColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notes',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(member.notes!),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationRow(
    BuildContext context,
    String relation,
    FamilyMember relative,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MemberDetailScreen(member: relative),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(
                relative.gender == Gender.male ? Icons.person : Icons.person_2,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    relation,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    relative.fullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  String _getOrdinalSuffix(int number) {
    if (number == 1) return 'er';
    return 'ème';
  }
}
