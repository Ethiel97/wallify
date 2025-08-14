import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/search/search.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';
import 'package:wallinice/shared/routing/app_router.gr.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView>
    with AutomaticKeepAliveClientMixin {
  // Popular search categories and colors from original
  static const List<String> _popularSearchCategories = [
    'nature',
    'abstract',
    'landscape',
    'city',
    'space',
    'animals',
    'cars',
    'minimal',
    'football',
  ];

  static final List<Color> _popularColors = [
    const Color(0xff660000),
    const Color(0xff990000),
    const Color(0xffcc0000),
    const Color(0xffcc3333),
    const Color(0xffea4c88),
    const Color(0xff993399),
    const Color(0xff663399),
    const Color(0xff333399),
    const Color(0xff0066cc),
    const Color(0xff0099cc),
    const Color(0xff66cccc),
    const Color(0xff77cc33),
    const Color(0xff669900),
    const Color(0xff336600),
    const Color(0xff666600),
    const Color(0xff999900),
    const Color(0xffcccc33),
    const Color(0xffffff00),
    const Color(0xffffcc33),
    const Color(0xffff9900),
    const Color(0xffff6600),
    const Color(0xffcc6633),
    const Color(0xff996633),
    const Color(0xff663300),
    const Color(0xff000000),
    const Color(0xff999999),
    const Color(0xffcccccc),
    const Color(0xffffffff),
    const Color(0xff424153),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 18,
          ),
          children: [
            const SizedBox(height: 50),

            // Search input field
            _SearchInputField(),

            const SizedBox(height: 24),

            // Color filters section
            _ColorFiltersSection(colors: _popularColors),

            const SizedBox(height: 36),

            // Category tags section
            const _CategoryTagsSection(categories: _popularSearchCategories),

            const SizedBox(height: 24),

            // Search results grid
            _SearchResultsGrid(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchCubit = context.read<SearchCubit>();

    return BlocSelector<SearchCubit, SearchState, String>(
      selector: (state) => state.currentSearchQuery,
      builder: (context, currentSearchQuery) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.1 : 0.05,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: searchCubit.searchTextController,
            style: theme.textTheme.bodyMedium,
            onSubmitted: (searchQuery) {
              if (searchQuery.isNotEmpty) {
                searchCubit.searchWallpapers(searchQuery: searchQuery);
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () => _showProviderSelectionBottomSheet(context),
                icon: Icon(
                  Iconsax.filter,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              hintText: 'Search wallpapers...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProviderSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Search Providers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Pexels & Wallhaven'),
              subtitle: const Text('Search both providers'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              title: const Text('Pexels Only'),
              subtitle: const Text('High-quality stock photos'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              title: const Text('Wallhaven Only'),
              subtitle: const Text('Community wallpapers'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorFiltersSection extends StatelessWidget {
  const _ColorFiltersSection({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Tone',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: BlocSelector<SearchCubit, SearchState, String?>(
            selector: (state) => state.selectedColor,
            builder: (context, selectedColorHex) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, colorIndex) {
                  final currentColor = colors[colorIndex];
                  final colorHexValue =
                      TinyColor.fromColor(currentColor).toHex8();
                  final isColorSelected = selectedColorHex == colorHexValue;

                  return ColorFilterChip(
                    color: currentColor,
                    isSelected: isColorSelected,
                    onTap: () => _handleColorSelection(
                      context,
                      colorHexValue,
                      isColorSelected,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleColorSelection(
    BuildContext context,
    String colorHexValue,
    bool isCurrentlySelected,
  ) {
    final searchCubit = context.read<SearchCubit>();

    if (isCurrentlySelected) {
      searchCubit.updateSelectedColor(null);
    } else {
      searchCubit
        ..updateSelectedColor(colorHexValue)
        ..searchWallpapersByColor(
          colorHex: colorHexValue,
          searchQuery: searchCubit.searchTextController.text.trim(),
        );
    }
  }
}

class _CategoryTagsSection extends StatelessWidget {
  const _CategoryTagsSection({required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocSelector<SearchCubit, SearchState, String>(
        selector: (state) => state.currentSearchQuery,
        builder: (context, currentSearchQuery) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, tagIndex) {
              final categoryName = categories[tagIndex];
              final isCategorySelected = currentSearchQuery == categoryName;

              return WallpaperTag(
                tag: categoryName,
                isSelected: isCategorySelected,
                onTap: () => _handleCategorySelection(
                  context,
                  categoryName,
                  isCategorySelected,
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
    final searchCubit = context.read<SearchCubit>();

    if (isCurrentlySelected) {
      searchCubit.clearSearchResults();
    } else {
      searchCubit.searchTextController.text = categoryName;
      searchCubit.searchWallpapers(searchQuery: categoryName);
    }
  }
}

class _SearchResultsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<SearchCubit, SearchState,
        ValueWrapper<List<Wallpaper>>>(
      selector: (state) => state.searchResults,
      builder: (context, searchResultsWrapper) {
        return searchResultsWrapper.when(
          loading: (_) => const _SearchLoadingIndicator(),
          success: (searchResultWallpapers) => searchResultWallpapers.isEmpty
              ? const _EmptySearchResults()
              : _WallpaperMasonryGrid(wallpapers: searchResultWallpapers),
          error: (errorDetails, _) => _SearchErrorView(
            errorMessage: errorDetails.message,
            onRetryPressed: () => _retryLastSearch(context),
          ),
          initial: () => const _SearchPlaceholderView(),
        );
      },
    );
  }

  void _retryLastSearch(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final currentState = searchCubit.state;

    if (currentState.currentSearchQuery.isNotEmpty) {
      searchCubit.searchWallpapers(
        searchQuery: currentState.currentSearchQuery,
        refresh: true,
      );
    }
  }
}

class _WallpaperMasonryGrid extends StatelessWidget {
  const _WallpaperMasonryGrid({required this.wallpapers});

  final List<Wallpaper> wallpapers;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wallpapers.length,
      itemBuilder: (context, wallpaperIndex) {
        final currentWallpaper = wallpapers[wallpaperIndex];

        return SizedBox(
          height: MediaQuery.sizeOf(context).height *
              ((wallpaperIndex % 2) == 0 ? 0.25 : 0.3),
          child: WallpaperCard(
            wallpaper: currentWallpaper,
            onTap: () => _handleWallpaperTap(context, currentWallpaper),
          ),
        );
      },
    );
  }

  void _handleWallpaperTap(BuildContext context, Wallpaper selectedWallpaper) {
    context.router.navigate(
      WallpaperDetailRoute(wallpaper: selectedWallpaper),
    );
  }
}

// State widgets
class _SearchLoadingIndicator extends StatelessWidget {
  const _SearchLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching wallpapers...'),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchResults extends StatelessWidget {
  const _EmptySearchResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64),
            SizedBox(height: 16),
            Text('No results found'),
            Text('Try different keywords or colors'),
          ],
        ),
      ),
    );
  }
}

class _SearchErrorView extends StatelessWidget {
  const _SearchErrorView({
    required this.errorMessage,
    required this.onRetryPressed,
  });

  final String errorMessage;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Search failed'),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetryPressed,
              child: const Text('Retry Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPlaceholderView extends StatelessWidget {
  const _SearchPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search, size: 64),
            SizedBox(height: 16),
            Text('Search wallpapers'),
            Text('Enter keywords or select colors to start'),
          ],
        ),
      ),
    );
  }
}
