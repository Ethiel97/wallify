import 'package:equatable/equatable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

class WallpaperState extends Equatable {
  const WallpaperState({
    this.curatedWallpapers = const ValueWrapper(),
    this.searchResults = const ValueWrapper(),
    this.colorFilteredWallpapers = const ValueWrapper(),
    this.searchQuery = '',
    this.selectedColor,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.colorPage = 1,
    this.hasReachedMaxColor = false,
  });

  final ValueWrapper<List<Wallpaper>> curatedWallpapers;
  final ValueWrapper<List<Wallpaper>> searchResults;
  final ValueWrapper<List<Wallpaper>> colorFilteredWallpapers;
  final String searchQuery;
  final String? selectedColor;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int colorPage;
  final bool hasReachedMaxColor;

  WallpaperState copyWith({
    ValueWrapper<List<Wallpaper>>? curatedWallpapers,
    ValueWrapper<List<Wallpaper>>? searchResults,
    ValueWrapper<List<Wallpaper>>? colorFilteredWallpapers,
    String? searchQuery,
    String? selectedColor,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? colorPage,
    bool? hasReachedMaxColor,
  }) {
    return WallpaperState(
      curatedWallpapers: curatedWallpapers ?? this.curatedWallpapers,
      searchResults: searchResults ?? this.searchResults,
      colorFilteredWallpapers:
          colorFilteredWallpapers ?? this.colorFilteredWallpapers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedColor: selectedColor ?? this.selectedColor,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      colorPage: colorPage ?? this.colorPage,
      hasReachedMaxColor: hasReachedMaxColor ?? this.hasReachedMaxColor,
    );
  }

  @override
  List<Object?> get props => [
        curatedWallpapers,
        searchResults,
        colorFilteredWallpapers,
        searchQuery,
        selectedColor,
        currentPage,
        hasReachedMax,
        isLoadingMore,
        colorPage,
        hasReachedMaxColor,
      ];
}
