import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    required this.wallpaper,
    this.onTap,
    this.height,
    this.showFavoriteButton = false,
    this.isFavorited = false,
    this.onFavoritePressed,
    super.key,
  });

  final Wallpaper wallpaper;
  final VoidCallback? onTap;
  final double? height;
  final bool showFavoriteButton;
  final bool isFavorited;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: wallpaper.id,
        transitionOnUserGestures: true,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 9),
                blurRadius: 18,
                spreadRadius: 9,
                color: theme.shadowColor.withValues(alpha: .04),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Main image
                CachedNetworkImage(
                  imageUrl: wallpaper.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height ?? MediaQuery.sizeOf(context).height * 0.7,
                  placeholder: (context, url) => _buildShimmerLoader(context),
                  errorWidget: (context, url, error) =>
                      _buildErrorWidget(context),
                ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),

                // Favorite button
                if (showFavoriteButton && onFavoritePressed != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onFavoritePressed,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorited ? Iconsax.heart5 : Iconsax.heart,
                            color: isFavorited ? Colors.red : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Wallpaper info (optional)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'by ${wallpaper.photographer}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      if ((wallpaper.tags ?? []).isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: (wallpaper.tags ?? [])
                              .take(3)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: theme.brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
