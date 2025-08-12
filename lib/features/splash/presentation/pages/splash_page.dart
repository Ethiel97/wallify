import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallinice/shared/routing/routing.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  bool open = false;
  bool firstTime = true;

  late AnimationController animationController;
  late final AnimationController secondAnimationController;
  late Animation<AlignmentGeometry> alignmentAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    secondAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    alignmentAnimation = Tween<AlignmentGeometry>(
      begin: const Alignment(0, 20),
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    animationController
      ..addStatusListener((status) {
        setState(() {});
        if (status == AnimationStatus.completed) {
          Timer(const Duration(milliseconds: 5500), _goToNextPage);
        }
      })
      ..forward();

    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          open = !open;
        });
      }
    });
  }

  Future<void> _goToNextPage() async {
    // Navigation logic based on original goToNextPage method
    // For now, always go to main/landing page
    // Later we can add first-time check logic here
    if (context.mounted) {
      await context.router.goToHome();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOutCubicEmphasized,
            width: open ? MediaQuery.sizeOf(context).width : 0,
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/splash.jpg'),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: secondAnimationController,
            builder: (context, _) => Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.repeated,
                  colors: [
                    theme.primaryColor.withOpacity(.33),
                    theme.colorScheme.secondary.withOpacity(.33),
                    const Color(0xffF27121).withOpacity(.33),
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
            duration: const Duration(milliseconds: 2500),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 2500),
              alignment: alignmentAnimation.value,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Wallinice',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
  }
}
