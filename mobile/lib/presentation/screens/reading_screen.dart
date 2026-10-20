import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sayfa/core/utils/snackbar_utils.dart';
import '../../blocs/book/book_bloc.dart';
import '../../blocs/book/book_event.dart';
import '../../blocs/timer/timer_bloc.dart';
import '../../blocs/timer/timer_event.dart';
import '../../blocs/timer/timer_state.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/book_model.dart';
import '../../data/repositories/session_repository.dart';
import '../widgets/save_session_dialog.dart';
import '../widgets/session_stats_card.dart';
import '../widgets/timer_controls.dart';
import '../widgets/book_card.dart';
import '../widgets/ambiance_frame.dart';

class ReadingScreen extends StatefulWidget {
  final BookModel book;
  const ReadingScreen({super.key, required this.book});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int _sessionCount = 1;
  String _totalTime = '';
  String _lastSessionTime = '-';

  @override
  void initState() {
    super.initState();
    _totalTime = widget.book.formattedTotalTime;
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await context.read<SessionRepository>().getBookStats(
        widget.book.id,
      );
      if (mounted) {
        setState(() {
          _sessionCount = stats['sessionCount'] as int;
          _totalTime = stats['totalTime'] as String;
          _lastSessionTime = stats['lastSessionTime'] as String;
        });
      }
    } catch (_) {}
  }

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _openSaveDialog(BuildContext context, int durationSeconds) {
    context.read<TimerBloc>().add(TimerPaused());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SaveSessionDialog(
        durationSeconds: durationSeconds,
        onConfirm: (notes, isCompleted) {
          context.read<TimerBloc>().add(
            TimerSessionSaved(
              bookId: widget.book.id,
              durationSeconds: durationSeconds,
              notes: notes,
              isCompleted: isCompleted,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<TimerBloc>().add(TimerReset());
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: BlocConsumer<TimerBloc, TimerState>(
            listener: (context, state) {
              if (state is TimerSaveSuccess) {
                context.read<BookBloc>().add(BookFetchRequested());
                context.read<TimerBloc>().add(TimerReset());
                setState(() {
                  _sessionCount++;
                });
                Navigator.pop(context);
                context.showSuccessSnack('Okuma oturumu başarıyla kaydedildi!');
              } else if (state is TimerSaveFailure) {
                context.showErrorSnack(state.message);
              }
            },
            builder: (context, state) {
              int currentSeconds = 0;
              if (state is TimerRunInProgress) {
                currentSeconds = state.duration;
              } else if (state is TimerRunPause) {
                currentSeconds = state.duration;
              }

              final isRunning = state is TimerRunInProgress;
              final isPaused = state is TimerRunPause;
              final isSaving = state is TimerSaveInProgress;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. ÜST BAR: ← Kitaplığım
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          context.read<TimerBloc>().add(TimerReset());
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 16,
                          color: AppTheme.accentGold,
                        ),
                        label: const Text(
                          'Kitaplığım',
                          style: TextStyle(
                            color: AppTheme.accentGold,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const AmbianceFrame(gifPath: 'assets/gifs/indir.gif'),
                    BookCard.buildCover(
                      book: widget.book,
                      width: 120,
                      height: 170,
                      titleSize: 12,
                      authorSize: 9,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.author,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      isRunning
                          ? 'OKUNUYOR'
                          : (isPaused ? 'DURAKLATILDI' : 'HAZIR'),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDuration(currentSeconds),
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 3,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SessionStatsCard(
                      totalTime:
                          widget.book.formattedTotalTime.isEmpty ||
                              widget.book.formattedTotalTime == '0 dk'
                          ? '00:00:00'
                          : widget.book.formattedTotalTime,
                      sessionCount: _sessionCount,
                      lastSessionTime: widget.book.formattedTotalTime,
                    ),
                    const SizedBox(height: 32),
                    if (isSaving)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentGold,
                        ),
                      )
                    else
                      TimerControls(
                        isRunning: isRunning,
                        onToggle: () {
                          if (!isRunning && !isPaused) {
                            context.read<TimerBloc>().add(TimerStarted());
                          } else if (isRunning) {
                            context.read<TimerBloc>().add(TimerPaused());
                          } else if (isPaused) {
                            context.read<TimerBloc>().add(TimerResumed());
                          }
                        },
                        onFinish: () {
                          if (currentSeconds > 0) {
                            _openSaveDialog(context, currentSeconds);
                          } else {
                            context.showErrorSnack(
                              'Kaydedilecek bir süre henüz yok.',
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
