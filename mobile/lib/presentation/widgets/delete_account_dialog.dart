import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1B1714),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.accentGold.withOpacity(0.25),
          width: 1,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Hesabı Sil',
            style: TextStyle(
              color: Color(0xFFEADBCE),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: const Text(
        'Hesabınızı ve kitaplığınıza ait tüm okuma geçmişini kalıcı olarak silmek üzeresiniz. Bu işlem geri alınamaz.',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13.5,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text(
            'Vazgeç',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.85),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text(
            'Hesabımı Sil',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}