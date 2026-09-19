import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class ColorUtils {
  static Color parseHex(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppTheme.background;
    }
  }
}