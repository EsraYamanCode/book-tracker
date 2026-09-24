import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

class TimerInitial extends TimerState {}

class TimerRunInProgress extends TimerState {
  final int duration;

  const TimerRunInProgress({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerRunPause extends TimerState {
  final int duration;

  const TimerRunPause({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerSaveInProgress extends TimerState {}

class TimerSaveSuccess extends TimerState {}

class TimerSaveFailure extends TimerState {
  final String message;

  const TimerSaveFailure({required this.message});

  @override
  List<Object> get props => [message];
}
