import 'package:flutter/material.dart';

class WTextButton extends StatelessWidget {
  const WTextButton({
    required this.onPress,
    required this.text,
    this.borderRadius = 16,
    super.key,
  });

  final VoidCallback onPress;
  final String text;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onPress,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: theme.colorScheme.secondary,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
