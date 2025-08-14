import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onTap,
    super.key,
    this.processing = false,
    this.child,
    this.enabled = true,
    this.color,
    this.textColor = Colors.white,
  });

  final String text;
  final Color? color;
  final Color textColor;
  final VoidCallback onTap;
  final bool processing;
  final bool enabled;
  final Widget? child;

  Color _getBackgroundColor(BuildContext context) =>
      color ?? Theme.of(context).colorScheme.primary;

  Widget _getContent(BuildContext context) {
    if (child != null) return child!;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !processing ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: enabled
                ? _getBackgroundColor(context)
                : _getBackgroundColor(context).withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _getBackgroundColor(context).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: processing
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                )
              : _getContent(context),
        ),
      ),
    );
  }
}
