import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class BookmarkButton extends StatefulWidget {
  final VoidCallback onTap;
  final double width;
  final double height;

  const BookmarkButton({
    super.key,
    required this.onTap,
    this.width = 32.0,
    this.height = 80.0,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (v) => setState(() => _active = v),
      onHover: (v) => setState(() => _active = v),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 150),
        offset: Offset(0, _active ? 0.08 : 0),
        child: ClipPath(
          clipper: const _SimpleRibbonClipper(),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.accentGoldSoft, AppTheme.accentGoldDark],
              ),
            ),
            alignment: const Alignment(0, 0.5),
            child: const Icon(
              Icons.bar_chart_rounded,
              size: 19,
              color: AppTheme.cardBackground,
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleRibbonClipper extends CustomClipper<Path> {
  const _SimpleRibbonClipper();

  @override
  Path getClip(Size s) => Path()
    ..lineTo(0, s.height)
    ..lineTo(s.width / 2, s.height * 0.82)
    ..lineTo(s.width, s.height)
    ..lineTo(s.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
