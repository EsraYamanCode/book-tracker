import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class SessionStatsCard extends StatelessWidget {
  final String totalTime;
  final int sessionCount;
  final String lastSessionTime;

  const SessionStatsCard({
    super.key,
    required this.totalTime,
    required this.sessionCount,
    required this.lastSessionTime,
  });

  Widget _buildStatColumn({
    required String label,
    required String value,
    Color valueColor = AppTheme.textPrimary,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: const Color(0xFF2B2620));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B2620)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(label: 'TOPLAM\nSÜRE', value: totalTime, valueColor: AppTheme.accentGold),
          _buildDivider(),
          _buildStatColumn(label: 'OTURUM', value: '#$sessionCount'),
          _buildDivider(),
          _buildStatColumn(label: 'SON\nOTURUM', value: lastSessionTime)
        ],
      ),
    );
  }
}
