class UserStatsModel {
  final int currentStreak;
  final Map<DateTime, int> datasets;

  UserStatsModel({
    required this.currentStreak,
    required this.datasets,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    final rawMap = json['activityMap'] as Map<String, dynamic>? ?? {};
    final Map<DateTime, int> parsedDatasets = {};

    rawMap.forEach((key, value) {
      final date = DateTime.tryParse(key);
      if (date != null) {
        // flutter_heatmap_calendar için saat/dakikayı sıfırlamak en iyisidir
        final cleanDate = DateTime(date.year, date.month, date.day);
        parsedDatasets[cleanDate] = (value as num).toInt();
      }
    });

    return UserStatsModel(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      datasets: parsedDatasets,
    );
  }
}