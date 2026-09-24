import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class SaveSessionDialog extends StatefulWidget {
  final int durationSeconds;
  final Function(String? notes, bool isCompleted) onConfirm;

  const SaveSessionDialog({
    super.key,
    required this.durationSeconds,
    required this.onConfirm,
  });

  @override
  State<SaveSessionDialog> createState() => _SaveSessionDialogState();
}

class _SaveSessionDialogState extends State<SaveSessionDialog> {
  final TextEditingController _notesController = TextEditingController();
  bool _isCompleted = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF2B2620)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık
            const Text(
              'OTURUMU KAYDET',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.accentGold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Süre Gösterimi
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2B2620)),
              ),
              child: Text(
                _formatDuration(widget.durationSeconds),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.accentGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Not Girişi
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Okuma notların (opsiyonel)...',
              ),
            ),
            const SizedBox(height: 10),

            // Kitabı Bitirdim Checkbox
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.accentGold,
              checkColor: AppTheme.background,
              title: const Text(
                'Kitabı tamamen bitirdim',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
              ),
              value: _isCompleted,
              onChanged: (val) {
                setState(() {
                  _isCompleted = val ?? false;
                });
              },
            ),
            const SizedBox(height: 18),

            // Butonlar (İptal & Kaydet)
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'İptal',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final notes = _notesController.text.trim().isEmpty
                          ? null
                          : _notesController.text.trim();
                      widget.onConfirm(notes, _isCompleted);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: AppTheme.background,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'KAYDET',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}