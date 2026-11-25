import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class AmbianceOption {
  final String id;
  final String label;
  final IconData icon;
  final String? assetPath;

  const AmbianceOption({
    required this.id,
    required this.label,
    required this.icon,
    this.assetPath,
  });
}

class AmbianceFrame extends StatefulWidget {
  final String? gifPath;
  final double height;
  final ValueChanged<String>? onAmbianceChanged;

  const AmbianceFrame({
    super.key,
    this.gifPath,
    this.height = 160.0,
    this.onAmbianceChanged,
  });

  @override
  State<AmbianceFrame> createState() => _AmbianceFrameState();
}

class _AmbianceFrameState extends State<AmbianceFrame> {
  static const List<AmbianceOption> _options = [
    AmbianceOption(
      id: 'fireplace',
      label: 'Şömine',
      icon: Icons.local_fire_department_rounded,
      assetPath: 'assets/gifs/alev.gif',
    ),
    AmbianceOption(
      id: 'rain',
      label: 'Yağmur',
      icon: Icons.water_drop_rounded,
      assetPath: 'assets/gifs/yagmur2.gif',
    ),
    AmbianceOption(
      id: 'cafe',
      label: 'Kafe',
      icon: Icons.local_cafe_rounded,
      assetPath: 'assets/gifs/kafe.gif',
    ),
    AmbianceOption(
      id: 'none',
      label: 'Kapalı',
      icon: Icons.visibility_off_outlined,
      assetPath: null,
    ),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.gifPath != null) {
      final index = _options.indexWhere((o) => o.assetPath == widget.gifPath);
      if (index != -1) {
        _selectedIndex = index;
      }
    }
  }

  void _selectIndex(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    widget.onAmbianceChanged?.call(_options[index].id);
  }

  void _onHorizontalSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200) {
      _selectIndex((_selectedIndex + 1) % _options.length);
    } else if (velocity > 200) {
      _selectIndex((_selectedIndex - 1 + _options.length) % _options.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _options[_selectedIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onHorizontalDragEnd: _onHorizontalSwipe,
          child: Container(
            height: widget.height,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentGold.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppTheme.accentGold.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: current.assetPath != null
                        ? Image.asset(
                            current.assetPath!,
                            key: ValueKey(current.id),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                _buildPlaceholder(current.label),
                          )
                        : _buildPlaceholder(null),
                  ),
                  // Alt kontrol barının okunurluğu için hafif gölge geçişi
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Sağ alt atmosfer seçici kapsülü
                  Positioned(
                    right: 10,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_options.length, (index) {
                          final item = _options[index];
                          final isSelected = index == _selectedIndex;

                          return GestureDetector(
                            onTap: () => _selectIndex(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSelected ? 8 : 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.accentGold.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 14,
                                    color: isSelected
                                        ? AppTheme.accentGold
                                        : AppTheme.textSecondary,
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      item.label,
                                      style: const TextStyle(
                                        color: AppTheme.accentGold,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'sans-serif',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPlaceholder(String? missingLabel) {
    return Container(
      key: ValueKey('placeholder_$missingLabel'),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            AppTheme.accentGold.withValues(alpha: 0.08),
            Colors.black.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              missingLabel == null
                  ? Icons.auto_stories_outlined
                  : Icons.movie_filter_outlined,
              size: 30,
              color: AppTheme.accentGold.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 8),
            Text(
              missingLabel == null
                  ? 'Sade Okuma Modu'
                  : '$missingLabel Ambiyansı Hazırlanıyor...',
              style: TextStyle(
                color: AppTheme.textPrimary.withValues(alpha: 0.55),
                fontSize: 12,
                letterSpacing: 0.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
