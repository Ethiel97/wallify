import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@RoutePage()
class WallpapersByColorPage extends StatelessWidget {
  const WallpapersByColorPage({
    required this.colorHex,
    super.key,
  });

  final String colorHex;

  Color get color => Color(int.parse('FF$colorHex', radix: 16));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WallpaperCubit>()..searchWallpapersByColor(colorHex),
      child: _WallpapersByColorView(
        color: color,
        colorHex: colorHex,
      ),
    );
  }
}

class _WallpapersByColorView extends StatefulWidget {
  const _WallpapersByColorView({
    required this.color,
    required this.colorHex,
  });

  final Color color;
  final String colorHex;

  @override
  State<_WallpapersByColorView> createState() => _WallpapersByColorViewState();
}

class _WallpapersByColorViewState extends State<_WallpapersByColorView>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<WallpaperCubit>().loadMoreWallpapersByColor();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () => context.router.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Colors',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '#${widget.colorHex}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocSelector<WallpaperCubit, WallpaperState,
          ValueWrapper<List<Wallpaper>>>(
        selector: (state) => state.colorFilteredWallpapers,
        builder: (context, wallpapersWrapper) {
          return wallpapersWrapper.when(
            initial: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: (oldWallpapers) => (oldWallpapers?.isNotEmpty ?? true)
                ? _buildWallpaperGrid(oldWallpapers!)
                : const Center(child: CircularProgressIndicator()),
            success: (wallpapers) {
              if (wallpapers.isEmpty) {
                return _buildEmptyState();
              }
              return _buildWallpaperGrid(wallpapers);
            },
            error: (error, oldWallpapers) {
              if (oldWallpapers?.isNotEmpty ?? true) {
                return _buildWallpaperGrid(oldWallpapers!);
              }
              return _buildErrorState(error);
            },
          );
        },
      ),
    );
  }

  Widget _buildWallpaperGrid(List<Wallpaper> wallpapers) {
    return RefreshIndicator(
      onRefresh: () async {
        await context
            .read<WallpaperCubit>()
            .searchWallpapersByColor(widget.colorHex);
      },
      child: MasonryGridView.count(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 18,
        ),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: wallpapers.length,
        itemBuilder: (context, index) {
          final wallpaper = wallpapers[index];
          final isLastItem = index == wallpapers.length - 1;

          return Column(
            children: [
              WallpaperCard(
                wallpaper: wallpaper,
                height: MediaQuery.sizeOf(context).height *
                    (index.isEven ? 0.25 : 0.3),
              ),
              if (isLastItem)
                BlocSelector<WallpaperCubit, WallpaperState, bool>(
                  selector: (state) => state.isLoadingMore,
                  builder: (context, isLoadingMore) {
                    return isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox();
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No wallpapers found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different color or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ErrorDetails error) {
    return Center(
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
            'Error loading wallpapers',
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
                      .withValues(alpha: .7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context
                  .read<WallpaperCubit>()
                  .searchWallpapersByColor(widget.colorHex);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
