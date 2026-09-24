import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent {}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class TimerSessionSaved extends TimerEvent {
  final int bookId;
  final int durationSeconds;
  final String? notes;
  final bool isCompleted;

  const TimerSessionSaved({
    required this.bookId,
    required this.durationSeconds,
    this.notes,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [bookId, durationSeconds, notes, isCompleted];
}
