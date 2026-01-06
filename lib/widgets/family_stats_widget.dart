import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';

class FamilyStatsWidget extends StatelessWidget {
  final Map<String, int> stats;

  const FamilyStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.familyStatsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                Icons.people,
                AppLocalizations.of(context)!.totalStat,
                stats['total'].toString(),
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                Icons.male,
                AppLocalizations.of(context)!.menStat,
                stats['male'].toString(),
                AppTheme.maleColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                Icons.female,
                AppLocalizations.of(context)!.womenStat,
                stats['female'].toString(),
                AppTheme.femaleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                Icons.favorite,
                AppLocalizations.of(context)!.aliveStat,
                stats['alive'].toString(),
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                Icons.brightness_2,
                AppLocalizations.of(context)!.deceasedStat,
                stats['deceased'].toString(),
                AppTheme.deceasedColor,
              ),
            ),
            // const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // Placeholder for alignment
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
