import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/startup.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../utils/secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool open = false;

  bool firstTime = true;

  late AnimationController animationController;

  late final AnimationController secondAnimationController;

  late Animation<AlignmentGeometry> alignmentAnimation;

  // late Animation<double> gradien

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    secondAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(
        reverse: true,
      );

    alignmentAnimation = Tween<AlignmentGeometry>(
      begin: const Alignment(0, 20),
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    super.initState();

    animationController.addStatusListener((status) {
      setState(() {});
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 5500), () {
          goToNextPage();
        });
      }
    });

    // secondAnimationController.forward();

    animationController.forward();

    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        open = !open;
      });
    });
  }

  void goToNextPage() async {
    if (firstTime) {
      // LocalStorage.setIsFirstLaunch(false);
      await SecureStorageService.saveItem(
        key: firstLaunch,
        data: false.toString(),
      );

      Get.offAndToNamed(landing);
    } else {
      Get.offAndToNamed(landing);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  Future<bool> checkFirstTime() async {
    try {
      return (await SecureStorageService.readItem(key: firstLaunch)).isNotEmpty;
    } catch (e) {
      LogUtils.log(e);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Object>(
      future: checkFirstTime(),
      builder: (context, snapshot) {
        firstTime = (snapshot.data as bool?) ?? true;
        Startup().setTransparentStatusBar();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.screenBackgroundColor,
          body: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOutCubicEmphasized,
                width: open ? Get.width : 0,
                height: Get.height,
                decoration: BoxDecoration(
                  color: AppColors.screenBackgroundColor,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/splash.jpg'),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: secondAnimationController,
                builder: (context, _) => Container(
                  width: double.infinity,
                  height: Get.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.repeated,
                      colors: [
                        TinyColor(const Color(0xff8A2387))
                            .color
                            .withOpacity(.33),
                        TinyColor(const Color(0xffE94057))
                            .color
                            .withOpacity(.33),
                        TinyColor(const Color(0xffF27121))
                            .color
                            .withOpacity(.33),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        -1 * secondAnimationController.value,
                        secondAnimationController.value,
                        3 * secondAnimationController.value,
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: animationController.value,
                duration: const Duration(microseconds: 2500),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 2500),
                  alignment: alignmentAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 80,
                          sigmaY: 80,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(
                            20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Constants.kBorderRadius,
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            Constants.appName.toLowerCase(),
                            style: TextStyles.textStyle.apply(
                              color: Colors.white,
                              fontWeightDelta: 5,
                              fontSizeDelta: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
