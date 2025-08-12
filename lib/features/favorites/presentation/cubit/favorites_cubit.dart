import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/favorites/favorites.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState()) {
    _initializeFavorites();
  }

  final FavoritesRepository _favoritesRepository;
  StreamSubscription<List<Wallpaper>>? _favoritesSubscription;

  void _initializeFavorites() {
    _favoritesSubscription =
        _favoritesRepository.watchFavoriteWallpapers().listen(
      (favorites) {
        emit(
          state.copyWith(
            favoriteWallpapers: favorites.toSuccess<List<Wallpaper>>(),
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            favoriteWallpapers: null.toError<List<Wallpaper>>(
              ErrorDetails(message: error.toString()),
            ),
          ),
        );
      },
    );
  }

  Future<void> loadFavorites() async {
    if (state.favoriteWallpapers.isLoading) return;

    emit(
      state.copyWith(
        favoriteWallpapers: null.toLoading<List<Wallpaper>>(),
      ),
    );

    try {
      final favorites = await _favoritesRepository.getFavoriteWallpapers();
      emit(
        state.copyWith(
          favoriteWallpapers: favorites.toSuccess<List<Wallpaper>>(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          favoriteWallpapers: null.toError<List<Wallpaper>>(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> addToFavorites(Wallpaper wallpaper) async {
    try {
      await _favoritesRepository.addToFavorites(wallpaper);
      // The stream will automatically update the state
    } catch (e) {
      // Emit error without changing favorites list
      emit(
        state.copyWith(
          lastActionError:
              ErrorDetails(message: 'Failed to add to favorites: $e'),
        ),
      );
    }
  }

  Future<void> removeFromFavorites(String wallpaperId) async {
    try {
      await _favoritesRepository.removeFromFavorites(wallpaperId);
      // The stream will automatically update the state
    } catch (e) {
      emit(
        state.copyWith(
          lastActionError:
              ErrorDetails(message: 'Failed to remove from favorites: $e'),
        ),
      );
    }
  }

  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    try {
      final isFavorited =
          await _favoritesRepository.isWallpaperFavorited(wallpaper.id);

      if (isFavorited) {
        await removeFromFavorites(wallpaper.id);
      } else {
        await addToFavorites(wallpaper);
      }
    } catch (e) {
      emit(
        state.copyWith(
          lastActionError:
              ErrorDetails(message: 'Failed to toggle favorite: $e'),
        ),
      );
    }
  }

  Future<bool> isWallpaperFavorited(String wallpaperId) async {
    try {
      return await _favoritesRepository.isWallpaperFavorited(wallpaperId);
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await _favoritesRepository.clearAllFavorites();
      // The stream will automatically update the state
    } catch (e) {
      emit(
        state.copyWith(
          lastActionError:
              ErrorDetails(message: 'Failed to clear favorites: $e'),
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith());
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}

class FavoritesState {
  const FavoritesState({
    this.favoriteWallpapers = const ValueWrapper(),
    this.lastActionError,
  });

  final ValueWrapper<List<Wallpaper>> favoriteWallpapers;
  final ErrorDetails? lastActionError;

  FavoritesState copyWith({
    ValueWrapper<List<Wallpaper>>? favoriteWallpapers,
    ErrorDetails? lastActionError,
  }) {
    return FavoritesState(
      favoriteWallpapers: favoriteWallpapers ?? this.favoriteWallpapers,
      lastActionError: lastActionError,
    );
  }

  List<Object?> get props => [favoriteWallpapers, lastActionError];
}
