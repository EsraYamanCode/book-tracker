import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart'; // AppTheme dosya yolunu projene göre kontrol et

class AmbianceFrame extends StatelessWidget {
  final String? gifPath;
  final double height;

  const AmbianceFrame({super.key, this.gifPath, this.height = 160.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Altın çerçeveli atmosfer alanı
        Container(
          height: height,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF14110E), // Derin ahşap/gölge tonu
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppTheme.accentGold.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.8),
            child: gifPath != null
                ? Image.asset(
                    gifPath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : _buildPlaceholder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Henüz GIF yokken görünecek şık taslak görünüm
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            AppTheme.accentGold.withOpacity(0.08),
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 32,
              color: AppTheme.accentGold.withOpacity(0.45),
            ),
            const SizedBox(height: 8),
            Text(
              'Okuma Ambiyansı Hazırlanıyor...',
              style: TextStyle(
                color: const Color(0xFFEADBCE).withOpacity(0.5),
                fontSize: 12,
                letterSpacing: 0.8,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
