import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

class WallpaperHomePage extends StatelessWidget {
  const WallpaperHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<WallpaperCubit>()..loadCuratedWallpapers(),
        ),
      ],
      child: const _WallpaperHomeView(),
    );
  }
}

class _WallpaperHomeView extends StatefulWidget {
  const _WallpaperHomeView();

  @override
  State<_WallpaperHomeView> createState() => _WallpaperHomeViewState();
}

class _WallpaperHomeViewState extends State<_WallpaperHomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late PageController _wallpaperPageController;

  double _currentWallpaperIndex = 1;

  // Popular wallpaper categories for easy browsing
  static const List<String> _popularWallpaperCategories = [
    'nature',
    'abstract',
    'landscape',
    'city',
    'space',
    'animals',
    'cars',
    'minimal',
  ];

  @override
  void initState() {
    super.initState();
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _wallpaperPageController = PageController(
      viewportFraction: 0.85,
      initialPage: 1,
    );
    _wallpaperPageController.addListener(_handleWallpaperPageChange);
    _titleAnimationController.forward();
  }

  void _handleWallpaperPageChange() {
    setState(() {
      _currentWallpaperIndex = _wallpaperPageController.page ?? 1.0;
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _wallpaperPageController
      ..removeListener(_handleWallpaperPageChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background wallpaper with blur effect
        _BackgroundWallpaper(currentWallpaperIndex: _currentWallpaperIndex),

        // Main scrollable content
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App branding section
                _AppBrandingSection(
                  animationController: _titleAnimationController,
                ),

                const SizedBox(height: 24),

                // Category tags for quick filtering
                const _CategoryTagsSection(
                  categories: _popularWallpaperCategories,
                ),

                const SizedBox(height: 24),

                // Main wallpaper carousel
                _WallpaperCarouselSection(
                  pageController: _wallpaperPageController,
                  currentIndex: _currentWallpaperIndex,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundWallpaper extends StatelessWidget {
  const _BackgroundWallpaper({
    required this.currentWallpaperIndex,
  });

  final double currentWallpaperIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpaperCubit, WallpaperState>(
      builder: (context, state) {
        final wallpaperList = state.curatedWallpapers.value ?? [];
        if (wallpaperList.isEmpty) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
          );
        }

        final selectedIndex =
            currentWallpaperIndex.round().clamp(0, wallpaperList.length - 1);
        final selectedWallpaper = wallpaperList[selectedIndex];

        return _BackgroundWallpaperImage(wallpaper: selectedWallpaper);
      },
    );
  }
}

class _BackgroundWallpaperImage extends StatelessWidget {
  const _BackgroundWallpaperImage({
    required this.wallpaper,
  });

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(wallpaper.id),
          height: MediaQuery.sizeOf(context).height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.25),
                BlendMode.srcOver,
              ),
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                wallpaper.url,
                cacheKey: wallpaper.id,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBrandingSection extends StatelessWidget {
  const _AppBrandingSection({
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 36),
        Text(
          'Wallinice',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Browse awesome exclusive wallpapers',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _CategoryTagsSection extends StatelessWidget {
  const _CategoryTagsSection({
    required this.categories,
  });

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocSelector<WallpaperCubit, WallpaperState, String>(
        selector: (state) => state.searchQuery,
        builder: (context, currentSearchQuery) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, tagIndex) {
              final categoryName = categories[tagIndex];
              final isCurrentlySelected = currentSearchQuery == categoryName;

              return WallpaperTag(
                tag: categoryName,
                isSelected: isCurrentlySelected,
                onTap: () => _handleCategorySelection(
                  context,
                  categoryName,
                  isCurrentlySelected,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleCategorySelection(
    BuildContext context,
    String categoryName,
    bool isCurrentlySelected,
  ) {
    final wallpaperCubit = context.read<WallpaperCubit>();

    if (isCurrentlySelected) {
      // Clear search and load curated wallpapers
      wallpaperCubit
        ..clearSearch()
        ..loadCuratedWallpapers(refresh: true);
    } else {
      // Search for wallpapers in this category
      wallpaperCubit.searchWallpapers(query: categoryName);
    }
  }
}

class _WallpaperCarouselSection extends StatelessWidget {
  const _WallpaperCarouselSection({
    required this.pageController,
    required this.currentIndex,
  });

  final PageController pageController;
  final double currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocSelector<WallpaperCubit, WallpaperState,
          ValueWrapper<List<Wallpaper>>>(
        selector: (state) => state.curatedWallpapers,
        builder: (context, wallpaperDataWrapper) {
          return wallpaperDataWrapper.when(
            loading: (_) => const _LoadingIndicator(),
            success: (wallpaperList) => wallpaperList.isEmpty
                ? const _EmptyWallpaperView()
                : _WallpaperPageView(
                    wallpapers: wallpaperList,
                    pageController: pageController,
                    currentIndex: currentIndex,
                  ),
            error: (errorDetails, _) => _ErrorStateView(
              errorMessage: errorDetails.message,
              onRetryPressed: () => context
                  .read<WallpaperCubit>()
                  .loadCuratedWallpapers(refresh: true),
            ),
            initial: () => const _LoadingIndicator(),
          );
        },
      ),
    );
  }
}

class _WallpaperPageView extends StatelessWidget {
  const _WallpaperPageView({
    required this.wallpapers,
    required this.pageController,
    required this.currentIndex,
  });

  final List<Wallpaper> wallpapers;
  final PageController pageController;
  final double currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: PageView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: wallpapers.length,
        itemBuilder: (context, wallpaperIndex) {
          final currentWallpaper = wallpapers[wallpaperIndex];
          final isWallpaperSelected = currentIndex > wallpaperIndex - 0.5 &&
              currentIndex < wallpaperIndex + 0.5;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(0.0, isWallpaperSelected ? -15.0 : 0.0)
              ..scale(isWallpaperSelected ? 1.0 : 0.95),
            child: WallpaperCard(
              wallpaper: currentWallpaper,
              onTap: () => _handleWallpaperTap(context, currentWallpaper),
            ),
          );
        },
      ),
    );
  }

  void _handleWallpaperTap(BuildContext context, Wallpaper selectedWallpaper) {
    // TODO: Navigate to wallpaper detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Wallpaper detail for ${selectedWallpaper.id} - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Loading state widgets
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading amazing wallpapers...'),
        ],
      ),
    );
  }
}

class _EmptyWallpaperView extends StatelessWidget {
  const _EmptyWallpaperView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 64),
          SizedBox(height: 16),
          Text('No wallpapers found'),
          Text('Try a different search or check your connection'),
        ],
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  const _ErrorStateView({
    required this.errorMessage,
    required this.onRetryPressed,
  });

  final String errorMessage;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.warning_2, size: 64),
            const SizedBox(height: 16),
            Text(
              'Failed to load wallpapers',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetryPressed,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
