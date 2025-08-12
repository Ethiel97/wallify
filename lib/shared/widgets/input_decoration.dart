import 'package:flutter/material.dart';
import 'package:wallinice/shared/theme/theme.dart';

InputDecoration customInputDecoration(
  String labelText,
  BuildContext context, {
  double contentPadding = 16.0,
  Widget suffix = const SizedBox.shrink(),
  Widget prefix = const SizedBox.shrink(),
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return InputDecoration(
    hintText: labelText,
    labelText: labelText,
    hintStyle: theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.greyMedium,
    ),
    labelStyle: theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.textColor : AppColors.darkColor,
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.accentColor),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.accentColor, width: 2),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.errorColor),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.errorColor, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: contentPadding,
    ),
    alignLabelWithHint: true,
    suffixIcon: suffix != const SizedBox.shrink() ? suffix : null,
    prefixIcon: prefix != const SizedBox.shrink() ? prefix : null,
  );
}
