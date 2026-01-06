import 'package:flutter/material.dart';
import '../models/family_member_model.dart';

class MemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onTap;
  final bool
  isFeatured; // If true, bigger and more detailed (for the top of profile)

  const MemberCard({
    super.key,
    required this.member,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    // Palette - Gender-based colors
    final isDeceased = member.status == VitalStatus.deceased;
    final isMale = member.gender == Gender.male;
    final genderColor = isMale
        ? const Color(0xFF5E81AC) // Blue for male
        : const Color(0xFFD08770); // Orange/Pink for female

    // Muted color for deceased
    final primaryColor = isDeceased
        ? genderColor.withValues(alpha: 0.5)
        : genderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(isFeatured ? 24 : 16),
        decoration: BoxDecoration(
          color: isDeceased ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
            if (isFeatured)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: -5,
              ),
          ],
          border: Border.all(
            color: isFeatured
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar with deceased indicator
            Stack(
              children: [
                Hero(
                  tag:
                      'avatar_${member.id}_${isFeatured ? "featured" : "list"}',
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: genderColor.withValues(
                          alpha: isDeceased ? 0.3 : 0.4,
                        ),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: isFeatured ? 36 : 28,
                      backgroundColor: isDeceased
                          ? Colors.grey[200]
                          : Colors.grey[50],
                      backgroundImage: member.photoUrl != null
                          ? NetworkImage(member.photoUrl!)
                          : null,
                      child: member.photoUrl == null
                          ? Icon(
                              Icons.person,
                              size: isFeatured ? 36 : 28,
                              color: primaryColor.withValues(alpha: 0.5),
                            )
                          : null,
                    ),
                  ),
                ),
                // Deceased indicator badge
                if (isDeceased)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.brightness_2,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Gender indicator (when alive)
                if (!isDeceased)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: genderColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        isMale ? Icons.male : Icons.female,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: isFeatured ? 20 : 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.firstName,
                    style: TextStyle(
                      fontSize: isFeatured ? 22 : 17,
                      fontWeight: FontWeight.bold,
                      color: isDeceased
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF2E3440),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: genderColor.withValues(
                            alpha: isDeceased ? 0.1 : 0.15,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          member.birthDate.year.toString(),
                          style: TextStyle(
                            color: isDeceased ? Colors.grey[600] : genderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isDeceased) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.brightness_2,
                                size: 10,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'متوفي',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Navigation Icon
            if (!isFeatured)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFAEBACD),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
