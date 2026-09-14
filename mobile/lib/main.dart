import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'data/repositories/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KİTAPLIĞIM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'KİTAPLIĞIM',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Temel yapılandırma tamamlandı.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontFamily: 'sans-serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
