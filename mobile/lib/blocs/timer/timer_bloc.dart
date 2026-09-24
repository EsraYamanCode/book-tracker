import '../../data/repositories/session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_event.dart';
import 'timer_state.dart';
import 'dart:async';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final SessionRepository _sessionRepository;
  StreamSubscription<int>? _tickerSubscription;
  int _currentDuration = 0;

  TimerBloc({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository,
      super(TimerInitial()) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerSessionSaved>(_onSessionSaved);
  }
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _currentDuration = 0;
    emit(const TimerRunInProgress(duration: 0));

    _tickerSubscription?.cancel();
    _tickerSubscription =
        Stream.periodic(const Duration(seconds: 1), (x) => x + 1).listen((
          ticks,
        ) {
          add(TimerTicked(duration: ticks));
        });
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    _currentDuration = event.duration;
    emit(TimerRunInProgress(duration: _currentDuration));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(duration: _currentDuration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(duration: _currentDuration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    _currentDuration = 0;
    emit(TimerInitial());
  }

  Future<void> _onSessionSaved(
    TimerSessionSaved event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    emit(TimerSaveInProgress());

    try {
      await _sessionRepository.createSession(
        bookId: event.bookId,
        durationSeconds: event.durationSeconds,
        isCompleted: event.isCompleted,
      );
      emit(TimerSaveSuccess());
    } catch (e) {
      emit(
        TimerSaveFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
