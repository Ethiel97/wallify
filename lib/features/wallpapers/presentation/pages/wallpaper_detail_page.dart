import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/search/search.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';
import 'package:wallinice/shared/widgets/widgets.dart';

@RoutePage()
class WallpaperDetailPage extends StatelessWidget {
  const WallpaperDetailPage({
    required this.wallpaper,
    super.key,
  });

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WallpaperDetailCubit>()..setSelectedWallpaper(wallpaper),
      child: const _WallpaperDetailView(),
    );
  }
}

class _WallpaperDetailView extends StatefulWidget {
  const _WallpaperDetailView();

  @override
  State<_WallpaperDetailView> createState() => _WallpaperDetailViewState();
}

class _WallpaperDetailViewState extends State<_WallpaperDetailView>
    with AutomaticKeepAliveClientMixin {
  late DraggableScrollableController _scrollableController;
  double _dragRatio = 0.21;
  final double _sheetMaxSize = 0.4;

  @override
  void initState() {
    super.initState();
    _scrollableController = DraggableScrollableController();
    _scrollableController.addListener(() {
      setState(() {
        _dragRatio = _scrollableController.size / _sheetMaxSize;
      });
    });
  }

  @override
  void dispose() {
    _scrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<WallpaperDetailCubit, WallpaperDetailState>(
          listenWhen: (previous, current) =>
              previous.downloadStatus.status != current.downloadStatus.status,
          listener: (context, state) {
            state.downloadStatus.when(
              initial: () {},
              loading: (_) {},
              success: (value) {
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallpaper downloaded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              error: (error, _) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download failed: ${error.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
        ),
        BlocListener<WallpaperDetailCubit, WallpaperDetailState>(
          listenWhen: (previous, current) =>
              previous.setWallpaperStatus.status !=
              current.setWallpaperStatus.status,
          listener: (context, state) {
            state.setWallpaperStatus.when(
              initial: () {},
              loading: (_) {},
              success: (value) {
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallpaper applied successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              error: (error, _) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to set wallpaper: ${error.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
        ),
        BlocListener<WallpaperDetailCubit, WallpaperDetailState>(
          listenWhen: (previous, current) =>
              previous.shareStatus.status != current.shareStatus.status,
          listener: (context, state) {
            state.shareStatus.when(
              initial: () {},
              loading: (_) {},
              success: (value) {
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallpaper shared successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              error: (error, _) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Share failed: ${error.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
        ),
      ],
      child:
          BlocSelector<WallpaperDetailCubit, WallpaperDetailState, Wallpaper?>(
        selector: (state) => state.currentWallpaper.value,
        builder: (context, selectedWallpaper) {
          if (selectedWallpaper == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Material(
            type: MaterialType.transparency,
            color: Theme.of(context).colorScheme.surface,
            child: Scaffold(
              body: Stack(
                children: [
                  // Full screen wallpaper background
                  Hero(
                    tag: selectedWallpaper.id,
                    transitionOnUserGestures: true,
                    child: CachedNetworkImage(
                      imageUrl: selectedWallpaper.src.original,
                      memCacheHeight: MediaQuery.sizeOf(context).height.toInt(),
                      memCacheWidth: MediaQuery.sizeOf(context).width.toInt(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildShimmerLoader(),
                      errorWidget: (context, url, error) =>
                          _buildShimmerLoader(),
                      imageBuilder: (context, imageProvider) => Container(
                        key: UniqueKey(),
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                              Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: 0.2),
                              BlendMode.srcOver,
                            ),
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Top action buttons
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        _buildBlurredIconButton(
                          Iconsax.arrow_circle_left,
                          () => context.router.back(),
                        ),

                        // Set wallpaper button (Android only)
                        if (Platform.isAndroid)
                          _buildBlurredIconButton(
                            Iconsax.paintbucket,
                            () => _showSetWallpaperBottomSheet(
                              context,
                              selectedWallpaper,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Bottom draggable sheet with details and actions
                  Positioned.fill(
                    child: AnimatedPadding(
                      duration: const Duration(seconds: 1),
                      padding: const EdgeInsets.only(
                        top: 36,
                        left: 12,
                        right: 12,
                      ),
                      child: DraggableScrollableSheet(
                        controller: _scrollableController,
                        initialChildSize: 0.071,
                        maxChildSize: _sheetMaxSize,
                        minChildSize: 0.071,
                        builder: (context, scrollController) =>
                            SingleChildScrollView(
                          controller: scrollController,
                          child: _buildBottomSheet(selectedWallpaper),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoader() {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: theme.brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBlurredIconButton(IconData icon, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(
                alpha: 0.4,
              ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
          child: IconButton(
            icon: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(Wallpaper wallpaper) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(32),
        topRight: const Radius.circular(32),
        bottomLeft: Radius.circular(_dragRatio == 1 ? 32 : 0),
        bottomRight: Radius.circular(_dragRatio == 1 ? 32 : 0),
      ),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(
                alpha: 1 - _dragRatio,
              ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(32),
            topRight: const Radius.circular(32),
            bottomLeft: Radius.circular(_dragRatio == 1 ? 32 : 0),
            bottomRight: Radius.circular(_dragRatio == 1 ? 32 : 0),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: _dragRatio * 25,
            sigmaX: _dragRatio * 25,
          ),
          child: Column(
            children: [
              // Drag handle
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    _dragRatio == 1
                        ? Icons.expand_more_outlined
                        : Icons.expand_less_outlined,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Color palette
              if (wallpaper.dominantColors.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: wallpaper.dominantColors
                      .take(5)
                      .map(
                        (color) => ColorFilterChip(
                          color: TinyColor.fromString(color).color,
                          onTap: () {
                            context.router.pushNamed(
                              '/wallpapers/color/${TinyColor.fromString(color).toHex8()}',
                            );
                          },
                          isSelected: false,
                          borderRadius: 50,
                          size: 40,
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 16),

              // Photographer info
              Text(
                'Photographer: ${wallpaper.photographer}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 24),

              // File size info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _calculateApproximateSize(wallpaper),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Download button
                  _buildActionButton(
                    Iconsax.document_download,
                    'Download',
                    () => _handleDownload(wallpaper),
                  ),

                  // Set wallpaper button (Android only)
                  if (Platform.isAndroid)
                    _buildActionButton(
                      Iconsax.paintbucket,
                      'Apply',
                      () => _showSetWallpaperBottomSheet(context, wallpaper),
                    ),

                  // Favorite button
                  BlocSelector<WallpaperDetailCubit, WallpaperDetailState,
                      bool>(
                    selector: (state) => state.isWallpaperFavorited,
                    builder: (context, isFavorited) {
                      return _buildActionButton(
                        isFavorited ? Iconsax.heart5 : Iconsax.heart,
                        isFavorited ? 'Remove' : 'Save',
                        () => _handleFavoriteToggle(isFavorited),
                      );
                    },
                  ),

                  // Share button
                  _buildActionButton(
                    Iconsax.share,
                    'Share',
                    _handleShare,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                child: Icon(icon, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _calculateApproximateSize(Wallpaper wallpaper) {
    if (wallpaper.width != null && wallpaper.height != null) {
      final pixels = wallpaper.width! * wallpaper.height!;
      final approximateMB = (pixels * 3) / (1024 * 1024);
      return '~${approximateMB.toStringAsFixed(1)}MB';
    }
    return 'Size unknown';
  }

  void _showSetWallpaperBottomSheet(BuildContext context, Wallpaper wallpaper) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Set image as',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            WTextButton(
              text: 'Home Screen',
              onPress: () {
                Navigator.pop(context);
                _confirmAndSetWallpaper(WallpaperLocation.homeScreen);
              },
            ),
            const SizedBox(height: 24),
            WTextButton(
              text: 'Lock Screen',
              onPress: () {
                Navigator.pop(context);
                _confirmAndSetWallpaper(WallpaperLocation.lockScreen);
              },
            ),
            const SizedBox(height: 24),
            WTextButton(
              text: 'Home & Lock Screen',
              onPress: () {
                Navigator.pop(context);
                _confirmAndSetWallpaper(WallpaperLocation.homeAndLockScreen);
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _confirmAndSetWallpaper(WallpaperLocation location) {
    _showConfirmationSnackBar(
      message: 'Set this wallpaper?',
      actionText: 'Yes, Apply',
      onConfirm: () {
        context.read<WallpaperDetailCubit>().setAsWallpaper(
              wallpaperLocation: location,
            );
      },
    );
  }

  void _handleDownload(Wallpaper wallpaper) {
    _showConfirmationSnackBar(
      message: 'Download this wallpaper?',
      actionText: 'Yes, Download',
      onConfirm: () {
        context.read<WallpaperDetailCubit>().downloadWallpaper();
      },
    );
  }

  void _handleFavoriteToggle(bool isFavorited) {
    _showConfirmationSnackBar(
      message: isFavorited ? 'Remove from favorites?' : 'Save to favorites?',
      actionText: isFavorited ? 'Remove' : 'Save',
      onConfirm: () {
        context.read<WallpaperDetailCubit>().toggleFavoriteStatus();
      },
    );
  }

  void _handleShare() {
    context.read<WallpaperDetailCubit>().shareWallpaper();
  }

  void _showConfirmationSnackBar({
    required String message,
    required String actionText,
    required VoidCallback onConfirm,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        action: SnackBarAction(
          label: actionText,
          onPressed: onConfirm,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
