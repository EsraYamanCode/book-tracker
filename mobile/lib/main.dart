import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sayfa/blocs/book/book_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'core/constants/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/book_repository.dart';
import 'presentation/screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final bookRepository = BookRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: bookRepository),
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
