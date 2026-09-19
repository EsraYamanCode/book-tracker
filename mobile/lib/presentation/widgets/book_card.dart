import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/color_utils.dart';
import '../../data/models/book_model.dart';


class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(book.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF723348),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        onDelete();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 14,
            height: 48,
            decoration: BoxDecoration(
              color: ColorUtils.parseHex(book.coverColorHex),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          title: Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                book.author,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: AppTheme.accentGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    book.formattedTotalTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}