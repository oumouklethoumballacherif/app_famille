import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/family_member_model.dart';

/// Widget for displaying a family tree node
class TreeNodeWidget extends StatelessWidget {
  final FamilyMember member;
  final double size;

  const TreeNodeWidget({
    super.key,
    required this.member,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final genderColor = member.gender == Gender.male
        ? AppTheme.maleColor
        : AppTheme.femaleColor;
    final isDeceased = member.status == VitalStatus.deceased;

    return Container(
      width: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDeceased
            ? AppTheme.deceasedColor.withValues(alpha: 0.1)
            : genderColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDeceased ? AppTheme.deceasedColor : genderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isDeceased
                    ? AppTheme.deceasedColor.withValues(alpha: 0.3)
                    : genderColor.withValues(alpha: 0.3),
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
                        color:
                            isDeceased ? AppTheme.deceasedColor : genderColor,
                      ),
              ),
              // Deceased indicator
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
                      size: 12,
                      color: AppTheme.deceasedColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            member.firstName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDeceased ? AppTheme.deceasedColor : AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Father's name (smaller)
          Text(
            member.fatherName,
            style: TextStyle(
              fontSize: 11,
              color: isDeceased
                  ? AppTheme.deceasedColor.withValues(alpha: 0.7)
                  : AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
