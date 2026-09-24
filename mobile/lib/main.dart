import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sayfa/blocs/book/book_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/timer/timer_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'core/constants/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/book_repository.dart';
import 'data/repositories/session_repository.dart';
import 'presentation/screens/auth_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }
  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final sessionRepository = SessionRepository();
    final bookRepository = BookRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: bookRepository),
        RepositoryProvider<SessionRepository>(
          create: (context) => sessionRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: authRepository)
                  ..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) =>
                BookBloc(bookRepository: bookRepository),
          ),
          BlocProvider(
            create: (context) =>
                BookBloc(bookRepository: bookRepository),
          ),
          BlocProvider(
            create: (context) =>
                TimerBloc(sessionRepository: context.read<SessionRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'SAYFA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const AuthScreen(),
        ),
      ),
    );
  }
}
