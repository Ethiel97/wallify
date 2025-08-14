import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/features/auth/auth.dart';
import 'package:wallinice/features/favorites/favorites.dart';
import 'package:wallinice/features/main/main.dart';
import 'package:wallinice/features/search/search.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@RoutePage()
class MainWrapperPage extends StatelessWidget {
  const MainWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FavoritesCubit>(
      future: getIt.getAsync<FavoritesCubit>(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<NavigationCubit>()),
              BlocProvider(create: (_) => getIt<AuthCubit>()),
              BlocProvider.value(
                value: snapshot.data!,
              ), // FavoritesCubit
            ],
            child: const _MainWrapperView(),
          );
        }
        // Show loading while async dependencies are being initialized
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _MainWrapperView extends StatelessWidget {
  const _MainWrapperView();

  // Main app screens
  static const List<Widget> _screens = [
    SearchPage(), // Real search screen implementation
    WallpaperHomePage(), // Real home screen implementation
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          body: Stack(
            children: [
              // Main content with IndexedStack for better performance
              IndexedStack(
                index: currentIndex,
                children: _screens,
              ),

              // Top app bar with user and theme buttons
              const MainAppBar(),

              // Bottom navigation
              const CustomBottomNavigation(),
            ],
          ),
        );
      },
    );
  }
}
