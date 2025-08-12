import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@injectable
class WallpaperDetailCubit extends Cubit<WallpaperDetailState> {
  WallpaperDetailCubit(this._wallpaperRepository)
      : super(const WallpaperDetailState());

  final WallpaperRepository _wallpaperRepository;

  void setSelectedWallpaper(Wallpaper selectedWallpaper) {
    emit(
      state.copyWith(
        currentWallpaper: selectedWallpaper.toSuccess<Wallpaper>(),
        isWallpaperFavorited: false, // TODO: Check if wallpaper is in favorites
      ),
    );
  }

  Future<void> downloadWallpaper() async {
    final wallpaperData = state.currentWallpaper.data;

    final wallpaper = wallpaperData;

    emit(state.copyWith(downloadStatus: null.toLoading<bool>()));

    try {
      // Download the wallpaper with progress tracking
      final downloadPath = await _wallpaperRepository.downloadWallpaper(
        wallpaper: wallpaper,
        onProgress: (progress) {
          // Optionally emit progress updates here if needed
          // You could add a progress field to the state
        },
      );

      // Emit success with download path info
      emit(state.copyWith(downloadStatus: true.toSuccess<bool>()));

      // You might want to show a success message with the file path
      print('Wallpaper downloaded to: $downloadPath');
    } catch (error) {
      emit(
        state.copyWith(
          downloadStatus: null.toError<bool>(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  Future<void> setAsWallpaper({
    required WallpaperLocation wallpaperLocation,
  }) async {
    if (!state.currentWallpaper.hasData) return;

    emit(state.copyWith(setWallpaperStatus: null.toLoading<bool>()));

    try {
      // TODO: Implement actual wallpaper setting functionality
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate setting wallpaper

      emit(state.copyWith(setWallpaperStatus: true.toSuccess<bool>()));
    } catch (error) {
      emit(
        state.copyWith(
          setWallpaperStatus: null.toError<bool>(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  Future<void> toggleFavoriteStatus() async {
    if (!state.currentWallpaper.hasData) return;

    emit(state.copyWith(favoriteStatus: null.toLoading<bool>()));

    try {
      // TODO: Implement actual favorite toggle functionality
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate toggle

      final newFavoriteStatus = !state.isWallpaperFavorited;
      emit(
        state.copyWith(
          favoriteStatus: newFavoriteStatus.toSuccess<bool>(),
          isWallpaperFavorited: newFavoriteStatus,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          favoriteStatus: null.toError<bool>(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  Future<void> shareWallpaper({
    bool includeImage = true,
    String? customMessage,
  }) async {
    if (!state.currentWallpaper.hasData) return;

    final wallpaper = state.currentWallpaper.data;

    emit(state.copyWith(shareStatus: null.toLoading<bool>()));

    try {
      await _wallpaperRepository.shareWallpaper(
        wallpaper: wallpaper,
        includeImage: includeImage,
        customMessage: customMessage,
      );

      emit(state.copyWith(shareStatus: true.toSuccess<bool>()));
    } catch (error) {
      emit(
        state.copyWith(
          shareStatus: null.toError<bool>(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  void clearAllActionStatuses() {
    emit(
      state.copyWith(
        downloadStatus: null.toInitial<bool>(),
        setWallpaperStatus: null.toInitial<bool>(),
        favoriteStatus: null.toInitial<bool>(),
        shareStatus: null.toInitial<bool>(),
      ),
    );
  }
}

class WallpaperDetailState {
  const WallpaperDetailState({
    this.currentWallpaper = const ValueWrapper(),
    this.downloadStatus = const ValueWrapper(),
    this.setWallpaperStatus = const ValueWrapper(),
    this.favoriteStatus = const ValueWrapper(),
    this.shareStatus = const ValueWrapper(),
    this.isWallpaperFavorited = false,
  });

  final ValueWrapper<Wallpaper> currentWallpaper;
  final ValueWrapper<bool> downloadStatus;
  final ValueWrapper<bool> setWallpaperStatus;
  final ValueWrapper<bool> favoriteStatus;
  final ValueWrapper<bool> shareStatus;
  final bool isWallpaperFavorited;

  WallpaperDetailState copyWith({
    ValueWrapper<Wallpaper>? currentWallpaper,
    ValueWrapper<bool>? downloadStatus,
    ValueWrapper<bool>? setWallpaperStatus,
    ValueWrapper<bool>? favoriteStatus,
    ValueWrapper<bool>? shareStatus,
    bool? isWallpaperFavorited,
  }) {
    return WallpaperDetailState(
      currentWallpaper: currentWallpaper ?? this.currentWallpaper,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      setWallpaperStatus: setWallpaperStatus ?? this.setWallpaperStatus,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      shareStatus: shareStatus ?? this.shareStatus,
      isWallpaperFavorited: isWallpaperFavorited ?? this.isWallpaperFavorited,
    );
  }
}

enum WallpaperLocation {
  homeScreen,
  lockScreen,
  homeAndLockScreen,
}
