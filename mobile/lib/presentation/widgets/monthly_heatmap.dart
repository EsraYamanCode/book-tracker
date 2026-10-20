import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../../core/constants/app_theme.dart';

class MonthlyHeatmap extends StatelessWidget {
  final Map<DateTime, int> datasets;

  const MonthlyHeatmap({super.key, required this.datasets});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aylık Aktivite',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          HeatMapCalendar(
            datasets: datasets,
            colorMode: ColorMode.color,
            defaultColor: Colors.white.withOpacity(0.05),
            textColor: Colors.white70,
            showColorTip: false,
            flexible: true,
            monthFontSize: 14,
            weekTextColor: Colors.white38,
            borderRadius: 6,
            colorsets: {
              1: AppTheme.accentGold.withOpacity(0.30),  // 1-30 dk arası
              30: AppTheme.accentGold.withOpacity(0.60), // 30-60 dk arası
              60: AppTheme.accentGold.withOpacity(0.85), // 60-120 dk arası
              120: AppTheme.accentGold,                   // 120+ dk
            },
            onClick: (value) {
              final minutes = datasets[DateTime(value.year, value.month, value.day)] ?? 0;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    minutes > 0
                        ? '${value.day}.${value.month}.${value.year}: $minutes dakika okundu.'
                        : '${value.day}.${value.month}.${value.year}: Okuma kaydı yok.',
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: AppTheme.cardBackground,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}