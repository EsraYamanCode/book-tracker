import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

extension SnackbarX on BuildContext {
  void showErrorSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF723348),
        content: Text(message, style: const TextStyle(color: AppTheme.textPrimary)),
      ),
    );
  }

  void showSuccessSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(backgroundColor: const Color(0xFF1B4D3E), content: Text(message)),
    );
  }
}