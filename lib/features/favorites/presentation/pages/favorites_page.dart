import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/favorites/favorites.dart';
import 'package:wallinice/features/main/main.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';
import 'package:wallinice/shared/routing/routing.dart';

@RoutePage()
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoritesView();
  }
}

class _FavoritesView extends StatefulWidget {
  const _FavoritesView();

  @override
  State<_FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<_FavoritesView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Load favorites when page is created
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: MultiBlocListener(
        listeners: [
          BlocListener<FavoritesCubit, FavoritesState>(
            listenWhen: (previous, current) =>
                previous.lastActionError != current.lastActionError &&
                current.lastActionError != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.lastActionError!.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<FavoritesCubit>().clearError();
                    },
                  ),
                ),
              );
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            // Reload favorites on pull-to-refresh
            await context.read<FavoritesCubit>().loadFavorites();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 100,
                pinned: true,
                elevation: 0,
                leading: const SizedBox.shrink(),
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'My Favorites',
                    style: Theme.of(context).textTheme.headlineSmall?.apply(
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSizeDelta: -4,
                        ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                      top: 24,
                    ),
                    child: BlocSelector<FavoritesCubit, FavoritesState,
                        List<Wallpaper>?>(
                      selector: (state) => state.favoriteWallpapers.value,
                      builder: (context, favorites) {
                        if (favorites?.isNotEmpty ?? false) {
                          return PopupMenuButton<String>(
                            icon: const Icon(Iconsax.more),
                            onSelected: (value) {
                              if (value == 'clear_all') {
                                _showClearAllDialog(context);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'clear_all',
                                child: Row(
                                  children: [
                                    Icon(Iconsax.trash, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Clear All'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),

              // Favorites Count
              BlocSelector<FavoritesCubit, FavoritesState, List<Wallpaper>?>(
                selector: (state) => state.favoriteWallpapers.value,
                builder: (context, favorites) {
                  if (favorites != null) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          '${favorites.length} '
                          'wallpaper${favorites.length != 1 ? 's' : ''}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),

              // Favorites Grid
              BlocSelector<FavoritesCubit, FavoritesState,
                  ValueWrapper<List<Wallpaper>>>(
                selector: (state) => state.favoriteWallpapers,
                builder: (context, wallpapersWrapper) {
                  return wallpapersWrapper.maybeWhen(
                    orElse: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    success: (wallpapers) {
                      if (wallpapers.isEmpty) {
                        return SliverToBoxAdapter(child: _buildEmptyState());
                      }
                      return _buildFavoritesGrid(wallpapers);
                    },
                    error: (error, _) => SliverToBoxAdapter(
                      child: _buildErrorState(error),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid(List<Wallpaper> wallpapers) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childCount: wallpapers.length,
        itemBuilder: (context, index) {
          final wallpaper = wallpapers[index];
          return WallpaperCard(
            wallpaper: wallpaper,
            height:
                MediaQuery.sizeOf(context).height * (index.isEven ? 0.25 : 0.3),
            onFavoritePressed: () {
              context.read<FavoritesCubit>().removeFromFavorites(wallpaper.id);
            },
            showFavoriteButton: true,
            onTap: () => _handleWallpaperTap(context, wallpaper),
            isFavorited: true,
          );
        },
      ),
    );
  }

  void _handleWallpaperTap(BuildContext context, Wallpaper selectedWallpaper) {
    context.router.navigate(
      WallpaperDetailRoute(wallpaper: selectedWallpaper),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.heart,
              size: 80,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start exploring wallpapers and tap the heart icon to '
              'save your favorites here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to home/search

                context.read<NavigationCubit>().navigateToTab(0);
              },
              icon: const Icon(Iconsax.search_normal),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              label: const Text('Explore Wallpapers'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ErrorDetails error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Favorites',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<FavoritesCubit>().loadFavorites();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext outerContext) {
    showDialog<void>(
      context: outerContext,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all wallpapers from your favorites? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              outerContext.read<FavoritesCubit>().clearAllFavorites();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
