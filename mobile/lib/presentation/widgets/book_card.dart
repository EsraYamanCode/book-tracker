import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/color_utils.dart';
import '../../data/models/book_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onDelete;
  final VoidCallback onActionTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onDelete,
    required this.onActionTap,
  });

  static Widget buildCover({
    required BookModel book,
    double width = 80,
    double height = 115,
    double titleSize = 10,
    double authorSize = 7.5,
  }) {
    if (book.coverImageUrl != null && book.coverImageUrl!.isNotEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 10,
              offset: const Offset(3, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: book.coverImageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context,url) => _buildFallbackCover(
                book: book,
                width: width,
                height: height,
                titleSize: titleSize,
                authorSize: authorSize,
            ), 
            errorWidget: (context, url, error) => _buildFallbackCover(
              book: book,
              width: width,
              height: height,
              titleSize: titleSize,
              authorSize: authorSize,
            ),
            fadeInDuration: const Duration(milliseconds: 200),
          ),
        ),
      );
    }

    return _buildFallbackCover(
      book: book,
      width: width,
      height: height,
      titleSize: titleSize,
      authorSize: authorSize,
    );
  }

  static Widget _buildFallbackCover({
    required BookModel book,
    required double width,
    required double height,
    required double titleSize,
    required double authorSize,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.1),
      decoration: BoxDecoration(
        color: ColorUtils.parseHex(book.coverColorHex),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(3, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            book.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: authorSize,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusStr = book.status.toLowerCase();
    final bool isCompleted = statusStr == 'completed';
    final bool isReading = statusStr == 'reading';

    Color statusColor = const Color(0xFF6B645C);
    String statusText = 'Okunmadı';
    if (isCompleted) {
      statusColor = const Color(0xFF4E9A6F);
      statusText = 'Tamamlandı';
    } else if (isReading) {
      statusColor = AppTheme.accentGold;
      statusText = 'Okunuyor';
    }

    final displayTime =
        (book.formattedTotalTime.isEmpty ||
            book.formattedTotalTime == '0 dk' ||
            book.totalReadingSeconds == 0)
        ? '—'
        : book.formattedTotalTime;

    return Dismissible(
      key: Key(book.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF723348),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1713), // Görseldeki koyu arka plan
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF28231D), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCard.buildCover(
              book: book,
              width: 80,
              height: 115,
              titleSize: 9.5,
              authorSize: 7.5,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: SizedBox(
                height: 115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF7D7366),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Süre Bloğu
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Toplam Süre',
                              style: TextStyle(
                                color: Color(0xFF6B645C),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              displayTime,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        if (isCompleted)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Color(0xFF4E9A6F),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Bitti',
                                  style: TextStyle(
                                    color: Color(0xFF4E9A6F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          InkWell(
                            onTap: onActionTap,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF5A4425),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isReading
                                    ? 'Okumaya Devam Et'
                                    : 'Okumaya Başla',
                                style: const TextStyle(
                                  color: AppTheme.accentGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
