import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@injectable
class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit(this._wallpaperRepository) : super(const WallpaperState());

  final WallpaperRepository _wallpaperRepository;

  Future<void> loadCuratedWallpapers({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          curatedWallpapers: state.curatedWallpapers.toLoading(),
          currentPage: 1,
          hasReachedMax: false,
        ),
      );
    } else if (state.curatedWallpapers.isLoading) {
      return;
    }

    if (!refresh && state.hasReachedMax) return;

    try {
      if (!refresh && !state.curatedWallpapers.isLoading) {
        emit(
          state.copyWith(
            curatedWallpapers: state.curatedWallpapers.toLoading(
              state.curatedWallpapers.value,
            ),
          ),
        );
      }

      final wallpapers = await _wallpaperRepository.getCuratedWallpapers(
        page: refresh ? 1 : state.currentPage,
      );

      final currentWallpapers = refresh
          ? <Wallpaper>[]
          : (state.curatedWallpapers.value ?? <Wallpaper>[]);

      final updatedWallpapers = <dynamic>{...currentWallpapers, ...wallpapers}
          .toList()
          .cast<Wallpaper>();

      emit(
        state.copyWith(
          curatedWallpapers:
              state.curatedWallpapers.toSuccess(updatedWallpapers),
          currentPage: refresh ? 2 : state.currentPage + 1,
          hasReachedMax: wallpapers.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          curatedWallpapers: state.curatedWallpapers.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> searchWallpapers({
    required String query,
    bool refresh = false,
  }) async {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchResults: const ValueWrapper(),
          searchQuery: '',
        ),
      );
      return;
    }

    if (refresh || query != state.searchQuery) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toLoading(),
          searchQuery: query,
          currentPage: 1,
          hasReachedMax: false,
        ),
      );
    }

    try {
      if (!refresh && !state.searchResults.isLoading) {
        emit(
          state.copyWith(
            searchResults: state.searchResults.toLoading(
              state.searchResults.value,
            ),
          ),
        );
      }

      final wallpapers = await _wallpaperRepository.searchWallpapers(
        query: query,
        page: refresh || query != state.searchQuery ? 1 : state.currentPage,
        color: state.selectedColor,
      );

      final currentWallpapers = refresh || query != state.searchQuery
          ? <Wallpaper>[]
          : (state.searchResults.value ?? <Wallpaper>[]);

      final updatedWallpapers = <dynamic>{...currentWallpapers, ...wallpapers}
          .toList()
          .cast<Wallpaper>();

      emit(
        state.copyWith(
          searchResults: state.searchResults.toSuccess(updatedWallpapers),
          currentPage:
              refresh || query != state.searchQuery ? 2 : state.currentPage + 1,
          hasReachedMax: wallpapers.isEmpty,
          searchQuery: query,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> filterByColor(String? color) async {
    emit(state.copyWith(selectedColor: color));

    if (state.searchQuery.isNotEmpty) {
      await searchWallpapers(query: state.searchQuery, refresh: true);
    } else {
      await loadWallpapersByColor(color);
    }
  }

  Future<void> loadWallpapersByColor(String? color) async {
    if (color == null) return;

    emit(
      state.copyWith(
        searchResults: state.searchResults.toLoading(),
        selectedColor: color,
        currentPage: 1,
        hasReachedMax: false,
      ),
    );

    try {
      final wallpapers = await _wallpaperRepository.getWallpapersByColor(
        color: color,
      );

      emit(
        state.copyWith(
          searchResults: state.searchResults.toSuccess(wallpapers),
          currentPage: 2,
          hasReachedMax: wallpapers.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> searchWallpapersByColor(String color) async {
    emit(
      state.copyWith(
        colorFilteredWallpapers: null.toLoading<List<Wallpaper>>(),
        selectedColor: color,
        colorPage: 1,
        hasReachedMaxColor: false,
        isLoadingMore: false,
      ),
    );

    try {
      final wallpapers = await _wallpaperRepository.getWallpapersByColor(
        color: color,
      );

      emit(
        state.copyWith(
          colorFilteredWallpapers: wallpapers.toSuccess<List<Wallpaper>>(),
          colorPage: 2,
          hasReachedMaxColor: wallpapers.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          colorFilteredWallpapers: null.toError<List<Wallpaper>>(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> loadMoreWallpapersByColor() async {
    if (state.hasReachedMaxColor ||
        state.isLoadingMore ||
        state.selectedColor == null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final wallpapers = await _wallpaperRepository.getWallpapersByColor(
        color: state.selectedColor!,
        page: state.colorPage,
      );

      final currentWallpapers =
          state.colorFilteredWallpapers.value ?? <Wallpaper>[];
      final updatedWallpapers = [...currentWallpapers, ...wallpapers];

      emit(
        state.copyWith(
          colorFilteredWallpapers:
              updatedWallpapers.toSuccess<List<Wallpaper>>(),
          colorPage: state.colorPage + 1,
          hasReachedMaxColor: wallpapers.isEmpty,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          colorFilteredWallpapers: state.colorFilteredWallpapers.toError(
            ErrorDetails(message: e.toString()),
          ),
          isLoadingMore: false,
        ),
      );
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchResults: const ValueWrapper(),
        searchQuery: '',
      ),
    );
  }
}
