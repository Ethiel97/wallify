import 'package:flutter/material.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:provider/provider.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String text;

  const EmptyPlaceholder({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => Center(
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty-${themeProvider.currentTheme}.png',
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  text,
                  style: TextStyles.textStyle.apply(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSizeDelta: -3,
                    fontWeightDelta: 1,
                  ),
                )
              ],
            ),
      ));
}
