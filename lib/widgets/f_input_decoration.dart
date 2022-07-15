import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/text_styles.dart';

InputDecoration fInputDecoration(
  text,
  ThemeData theme, {
  contentPadding = 13.0,
  suffix = const SizedBox.shrink(),
  prefix = const SizedBox.shrink(),
}) =>
    InputDecoration(
      // labelText: text,
      hintText: text,
      // errorStyle: theme.inputDecorationTheme.errorStyle,
      // labelStyle: theme.inputDecorationTheme.labelStyle,
      hintStyle: TextStyles.textStyle.apply(
        color: AppColors.darkColor,
        fontSizeDelta: -4,
      ),
      label: Text(
        text,
        style: TextStyles.textStyle.apply(
          color: AppColors.darkColor,
          fontSizeDelta: -3,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.accentColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.accentColor,
        ),
      ),
      contentPadding: EdgeInsets.all(
        getProportionateScreenWidth(contentPadding),
      ),
      alignLabelWithHint: true,
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(
          getProportionateScreenWidth(15),
        ),
        borderSide: BorderSide(
          color: AppColors.accentColor,
        ),
      ),
      suffixIcon: suffix,
      prefix: prefix,
    );
