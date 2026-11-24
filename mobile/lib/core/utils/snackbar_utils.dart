import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

extension SnackbarX on BuildContext {
  void showErrorSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.error,
        content: Text(message, style: const TextStyle(color: AppTheme.textPrimary)),
      ),
    );
  }

  void showSuccessSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(backgroundColor: AppTheme.snackbarSuccess, content: Text(message, style: const TextStyle(color: AppTheme.textPrimary))),
    );
  }
}