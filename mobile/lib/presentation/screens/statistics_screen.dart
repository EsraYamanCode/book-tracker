import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/user_stats_model.dart';
import '../../data/repositories/session_repository.dart';
import '../widgets/account_actions.dart';
import '../widgets/monthly_heatmap.dart';
import '../widgets/streak_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<UserStatsModel> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = context.read<SessionRepository>().getStatsSummary();
  }

  @override
  Widget build(BuildContext context) {
    const String userDisplayName = 'Yamaann Esra';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('İstatistikler'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<UserStatsModel>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.accentGold),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Bir hata oluştu: ${snapshot.error}',
                style: const TextStyle(color: Colors.white54),
              ),
            );
          }

          final stats = snapshot.data ??
              UserStatsModel(currentStreak: 0, datasets: {});

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreakCard(streak: stats.currentStreak),
                const SizedBox(height: 18),
                MonthlyHeatmap(datasets: stats.datasets),
                const SizedBox(height: 28),
                const AccountActions(displayName: userDisplayName),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}