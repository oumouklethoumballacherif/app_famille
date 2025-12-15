import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/family_member_model.dart';

/// Widget for displaying a family member as a card
class MemberCardWidget extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;
  final String? highlightQuery;

  const MemberCardWidget({
    super.key,
    required this.member,
    this.onTap,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    final genderColor = member.gender == Gender.male
        ? AppTheme.maleColor
        : AppTheme.femaleColor;
    final isDeceased = member.status == VitalStatus.deceased;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isDeceased
                        ? AppTheme.deceasedColor.withValues(alpha: 0.2)
                        : genderColor.withValues(alpha: 0.2),
                    child: member.photoUrl != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: member.photoUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Icon(
                                member.gender == Gender.male
                                    ? Icons.person
                                    : Icons.person_2,
                                size: 28,
                                color: genderColor,
                              ),
                              errorWidget: (_, __, ___) => Icon(
                                member.gender == Gender.male
                                    ? Icons.person
                                    : Icons.person_2,
                                size: 28,
                                color: genderColor,
                              ),
                            ),
                          )
                        : Icon(
                            member.gender == Gender.male
                                ? Icons.person
                                : Icons.person_2,
                            size: 28,
                            color: isDeceased
                                ? AppTheme.deceasedColor
                                : genderColor,
                          ),
                  ),
                  if (isDeceased)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.deceasedColor),
                        ),
                        child: const Icon(
                          Icons.brightness_2,
                          size: 10,
                          color: AppTheme.deceasedColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full name
                    _buildHighlightedText(
                      context,
                      member.fullName,
                      isDeceased
                          ? AppTheme.deceasedColor
                          : AppTheme.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    // Birth info
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          member.birthPlace,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Gender indicator
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: genderColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  member.gender == Gender.male ? Icons.male : Icons.female,
                  size: 20,
                  color: genderColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    Color textColor,
  ) {
    if (highlightQuery == null || highlightQuery!.isEmpty) {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
      );
    }

    final query = highlightQuery!.toLowerCase();
    final textLower = text.toLowerCase();
    final startIndex = textLower.indexOf(query);

    if (startIndex == -1) {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: AppTheme.accentColor.withValues(alpha: 0.3),
            ),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }
}
