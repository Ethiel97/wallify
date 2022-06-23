import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/startup.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/base_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final T Function(BuildContext) vmBuilder;
  final Widget Function(BuildContext, T) builder;

  const BaseView({
    required Key key,
    required this.vmBuilder,
    required this.builder,
  }) : super(key: key);

  @override
  BaseViewState createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  @override
  void didChangeDependencies() {
    Startup().setTransparentStatusBar();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>.value(
        value: widget.vmBuilder(context),
        child: Consumer<T>(
          builder: _buildScreenContent,
        ),
      );

  Widget _buildScreenContent(
    BuildContext context,
    T viewModel,
    Widget? child,
  ) =>
      RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).backgroundColor,
        strokeWidth: 4,
        notificationPredicate:
            viewModel.canRefresh ? (_) => true : (_) => false,
        onRefresh: () async {
          debugPrint("REFRESHING...");
          viewModel.init();
        },
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => SizedBox(
            height: Get.height,
            child: !viewModel.isInitialized
                ? Container(
                    height: Get.height,
                    color: Theme.of(context).backgroundColor,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      viewModel.hasError
                          ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/img/404-${themeProvider.currentTheme}.png",
                                    height: 40.h,
                                    width: 100.w,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    viewModel.errorMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.textStyle.apply(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.builder(
                              context,
                              viewModel,
                            ),
                      Visibility(
                        visible: viewModel.isLoading,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
}
