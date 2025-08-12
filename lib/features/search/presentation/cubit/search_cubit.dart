import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._wallpaperRepository) : super(const SearchState());

  final WallpaperRepository _wallpaperRepository;
  final TextEditingController searchTextController = TextEditingController();

  Future<void> searchWallpapers({
    required String searchQuery,
    String? selectedColor,
    bool refresh = false,
  }) async {
    if (searchQuery.isEmpty) {
      clearSearchResults();
      return;
    }

    if (refresh || searchQuery != state.currentSearchQuery) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toLoading(),
          currentSearchQuery: searchQuery,
          // selectedColor: selectedColor,
          currentPage: 1,
          hasReachedMaxResults: false,
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

      final searchResultWallpapers =
          await _wallpaperRepository.searchWallpapers(
        query: searchQuery,
        page: refresh || searchQuery != state.currentSearchQuery
            ? 1
            : state.currentPage,
        // color: selectedColor,
      );

      final existingWallpapers =
          refresh || searchQuery != state.currentSearchQuery
              ? <Wallpaper>[]
              : (state.searchResults.value ?? <Wallpaper>[]);

      final combinedWallpapers = [
        ...existingWallpapers,
        ...searchResultWallpapers,
      ];

      emit(
        state.copyWith(
          searchResults: state.searchResults.toSuccess(combinedWallpapers),
          currentPage: refresh || searchQuery != state.currentSearchQuery
              ? 2
              : state.currentPage + 1,
          hasReachedMaxResults: searchResultWallpapers.isEmpty,
          currentSearchQuery: searchQuery,
          // selectedColor: selectedColor,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toError(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  Future<void> searchWallpapersByColor({
    required String colorHex,
    String? searchQuery,
  }) async {
    emit(
      state.copyWith(
        searchResults: state.searchResults.toLoading(),
        selectedColor: colorHex.substring(2),
        currentPage: 1,
        hasReachedMaxResults: false,
      ),
    );

    try {
      List<Wallpaper> colorFilteredWallpapers;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        colorFilteredWallpapers = await _wallpaperRepository.searchWallpapers(
          query: searchQuery,
          color: colorHex.substring(2),
        );
      } else {
        colorFilteredWallpapers =
            await _wallpaperRepository.getWallpapersByColor(
          color: colorHex.substring(2),
        );
      }

      emit(
        state.copyWith(
          searchResults: state.searchResults.toSuccess(colorFilteredWallpapers),
          currentPage: 2,
          hasReachedMaxResults: colorFilteredWallpapers.isEmpty,
          selectedColor: colorHex,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          searchResults: state.searchResults.toError(
            ErrorDetails(message: error.toString()),
          ),
        ),
      );
    }
  }

  void updateSelectedColor(String? colorHex) {
    emit(state.copyWith(selectedColor: colorHex));
  }

  void clearSearchResults() {
    searchTextController.clear();
    emit(
      state.copyWith(
        searchResults: const ValueWrapper(),
        currentSearchQuery: '',
      ),
    );
  }

  @override
  Future<void> close() {
    searchTextController.dispose();
    return super.close();
  }
}

class SearchState {
  const SearchState({
    this.searchResults = const ValueWrapper(),
    this.currentSearchQuery = '',
    this.selectedColor,
    this.currentPage = 1,
    this.hasReachedMaxResults = false,
  });

  final ValueWrapper<List<Wallpaper>> searchResults;
  final String currentSearchQuery;
  final String? selectedColor;
  final int currentPage;
  final bool hasReachedMaxResults;

  SearchState copyWith({
    ValueWrapper<List<Wallpaper>>? searchResults,
    String? currentSearchQuery,
    String? selectedColor,
    int? currentPage,
    bool? hasReachedMaxResults,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
      selectedColor: selectedColor ?? this.selectedColor,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMaxResults: hasReachedMaxResults ?? this.hasReachedMaxResults,
    );
  }

  bool get hasActiveSearch =>
      currentSearchQuery.isNotEmpty || selectedColor != null;
}
