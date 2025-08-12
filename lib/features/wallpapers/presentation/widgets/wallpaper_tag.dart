import 'package:flutter/material.dart';

class WallpaperTag extends StatelessWidget {
  const WallpaperTag({
    required this.tag,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final String tag;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                  ),
                ]
              : null,
        ),
        child: Text(
          tag,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
