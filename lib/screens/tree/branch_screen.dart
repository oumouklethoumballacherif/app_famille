import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/family_member_model.dart';
import '../../providers/family_provider.dart';
import '../../widgets/member_card.dart';
// import '../../l10n/app_localizations.dart'; // Removed to avoid unused import if we use hardcoded text

import 'member_detail_screen.dart';

class BranchScreen extends StatelessWidget {
  final FamilyMember member;

  const BranchScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final children = familyProvider.getChildren(member.id);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF2E3440)),
        title: Text(
          member.firstName,
          style: const TextStyle(
            color: Color(0xFF2E3440),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF2E3440)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailScreen(member: member),
                ),
              );
            },
            tooltip: "Détails",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Featured Parent Profile
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: MemberCard(
                member: member,
                isFeatured: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MemberDetailScreen(member: member),
                    ),
                  );
                },
              ),
            ),

            // 2. Connector / Title
            if (children.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hub, size: 18, color: Color(0xFFAEBACD)),
                    const SizedBox(width: 8),
                    Text(
                      '${children.length} Efants', // Hardcoded "Children" in French
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAEBACD),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Divider(color: Color(0xFFE5E9F0), thickness: 2),
                    ),
                  ],
                ),
              ),

              // 3. Children List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  return MemberCard(
                    member: child,
                    onTap: () {
                      // Navigate deeper
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BranchScreen(member: child),
                        ),
                      );
                    },
                  );
                },
              ),
            ] else ...[
              // Empty State
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Aucun descendant enregistré",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
