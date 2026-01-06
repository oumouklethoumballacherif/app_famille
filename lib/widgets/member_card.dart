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
    // Palette
    final isMale = member.gender == Gender.male;
    final primaryColor = isMale
        ? const Color(0xFF5E81AC)
        : const Color(0xFFD08770);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(isFeatured ? 24 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            // Avatar
            Hero(
              tag: 'avatar_${member.id}_${isFeatured ? 'featured' : 'list'}',
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: isFeatured ? 36 : 28,
                  backgroundColor: Colors.grey[50],
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
                      color: const Color(0xFF2E3440),
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (member.birthDate != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        member.birthDate!.year.toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
