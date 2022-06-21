import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';

class WWallPaperTag extends StatelessWidget {
  final WallpaperViewModel viewModel;
  final String tag;

  const WWallPaperTag({
    required this.viewModel,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(Constants.kBorderRadius),
        child: GestureDetector(
          onTap: () {
            viewModel.searchWallpapers(tag);
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: Constants.kDuration,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              color: tag == viewModel.selectedTag
                  ? Theme.of(context).textTheme.bodyText1!.color!
                  : Colors.transparent,
              border: Border.all(
                color: Theme.of(context).textTheme.bodyText1!.color!,
              ),
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
            ),
            child: Text(
              tag,
              style: TextStyles.textStyle.apply(
                fontSizeDelta: -7,
                fontWeightDelta: 5,
                color: tag == viewModel.selectedTag
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
          ),
        ),
      );
}
