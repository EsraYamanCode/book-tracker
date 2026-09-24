import 'package:flutter/material.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;          // Sayaç şu an çalışıyor mu?
  final VoidCallback onToggle;   // Başlat/Duraklat/Devam Et butonuna basılınca çalışacak
  final VoidCallback onFinish;   // "Bitirdim" butonuna basılınca çalışacak

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onToggle,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. SOL BUTON (Devam Et / Duraklat)
        Expanded(
          child: OutlinedButton(
            onPressed: onToggle,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A359), // Sarı dolgu
              foregroundColor: const Color(0xFF14120E), // Koyu yazı rengi
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  size: 20,
                  color: const Color(0xFF14120E),
                ),
                const SizedBox(width: 8),
                Text(
                  isRunning ? 'Duraklat' : 'Devam Et',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // 2. SAĞ BUTON (✓ Bitirdim)
        Expanded(
          child: OutlinedButton(
            onPressed: onFinish,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2E23), // Koyu yeşil arka plan
              side: const BorderSide(color: Color(0xFF2C4A38), width: 1.2), // İnce yeşil çerçeve
              foregroundColor: const Color(0xFF4E9A6F), // Canlı yeşil yazı rengi
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 18, color: Color(0xFF4E9A6F)),
                SizedBox(width: 8),
                Text(
                  'Bitirdim',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}