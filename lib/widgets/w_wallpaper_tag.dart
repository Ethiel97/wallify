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

  bool get isSelected => tag == viewModel.selectedTag;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(Constants.kBorderRadius),
        child: GestureDetector(
          onTap: () {
            //TODO - set tag text to search text field
            // viewModel.searchQueryTEC.text = tag;

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
              color: isSelected
                  // ? Theme.of(context).textTheme.bodyText1!.color!
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              border: Border.all(
                // color: Theme.of(context).textTheme.bodyText1!.color!,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).textTheme.bodyText1!.color!,
              ),
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 20,
                  color: Theme.of(context).backgroundColor.withOpacity(.06),
                ),
              ],
            ),
            child: Text(
              tag,
              style: TextStyles.textStyle.apply(
                  fontSizeDelta: -7,
                  fontWeightDelta: 5,
                  color:
                      // ? Theme.of(context).backgroundColor
                      Theme.of(context).textTheme.bodyText1?.color),
            ),
          ),
        ),
      );
}
