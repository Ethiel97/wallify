import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ColorTag<T> extends StatelessWidget {
  final Color color;
  final double radius;
  final VoidCallback? voidCallback;

  final double size;

  const ColorTag({
    Key? key,
    required this.color,
    this.voidCallback,
    this.radius = Constants.kBorderRadius,
    this.size = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<WallpaperViewModel<T>>(
        builder: (context, wallpaperViewModel, _) => FittedBox(
          child: GestureDetector(
            onTap: () async {
              try {
                voidCallback!();
              } catch (e) {
                LogUtils.error(e);
              }

              wallpaperViewModel.searchWallpapers(
                '',
                delay: 300,
                details: {
                  'colors': TinyColor(color).toHex8().substring(2),
                  'color': color,
                },
              );
            },
            child: Container(
              height: size,
              width: size,
              margin: const EdgeInsets.only(
                right: 12,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                    color: Theme.of(context).backgroundColor.withOpacity(.08),
                  ),
                ],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(
                  radius,
                ),
                color: color,
              ),
            ),
          ),
        ),
      );
}
