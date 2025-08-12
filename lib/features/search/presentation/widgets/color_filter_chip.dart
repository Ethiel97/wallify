import 'package:flutter/material.dart';

class ColorFilterChip extends StatelessWidget {
  const ColorFilterChip({
    required this.color,
    required this.onTap,
    required this.isSelected,
    this.borderRadius = 8,
    this.size = 50,
    super.key,
  });

  final Color color;
  final VoidCallback onTap;
  final bool isSelected;
  final double borderRadius;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FittedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 12,
                color: theme.colorScheme.surface.withValues(alpha: 0.08),
              ),
            ],
            borderRadius: BorderRadius.circular(borderRadius),
            color: color,
          ),
        ),
      ),
    );
  }
}
