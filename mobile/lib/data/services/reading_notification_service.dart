import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReadingNotificationService {
  ReadingNotificationService._();
  static final ReadingNotificationService instance =
      ReadingNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 1001;
  static const String _channelId = 'reading_timer_channel_v2';
  static const String _channelName = 'Aktif Okuma Sayacı';
  static const Color _goldColor = Color(0xFFD4AF37);

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('ic_notification');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: initSettings);
    _isInitialized = true;
  }

  Future<void> requestPermission() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> showRunning({
    required String bookTitle,
    required String author,
    required int elapsedSeconds,
  }) async {
    final startTimestampMs =
        DateTime.now().millisecondsSinceEpoch - (elapsedSeconds * 1000);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Kilit ekranında canlı okuma sayacı',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
      enableVibration: false,
      icon: 'ic_notification',
      color: _goldColor,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: true,
      when: startTimestampMs,
      usesChronometer: true,
      visibility: NotificationVisibility.public,
      subText: author,
    );

    await _plugin.show(
      id: _notificationId,
      title: bookTitle,
      body: 'Okuma devam ediyor',
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showPaused({
    required String bookTitle,
    required String author,
    required int elapsedSeconds,
  }) async {
    final formatted = _formatDuration(elapsedSeconds);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Kilit ekranında canlı okuma sayacı',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
      enableVibration: false,
      icon: 'ic_notification',
      color: _goldColor,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: false,
      usesChronometer: false,
      visibility: NotificationVisibility.public,
      subText: author,
    );

    await _plugin.show(
      id: _notificationId,
      title: bookTitle,
      body: 'Duraklatıldı • $formatted',
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> cancel() async {
    await _plugin.cancel(id: _notificationId);
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
