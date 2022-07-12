import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import 'package:test/test.dart';

import 'search_wallpapers.mocks.dart';

@GenerateMocks([WallPaperRepository])
void main() {
  group('Search wallpapers', () {
    {
      test(
          "search wallpapers from api should return a List of Wallpapers when successful",
          () async {
        //Arrange
        MockWallPaperRepository<WallPaper> mockWallpaperRepository =
            MockWallPaperRepository();
        when(mockWallpaperRepository.searchItems(query: {'q': 'Cars'}))
            .thenReturn(List<WallPaper>.from([]));

        //Act
        final result =
            mockWallpaperRepository.searchItems(query: {'q': 'Cars'});

        //Assert
        expect(result, isInstanceOf<List<WallPaper>>());
      });

      test(
          "search wallpapers from api should return empty list if query is not comprehensive",
          () {
        //Arrange
        MockWallPaperRepository<WallPaper> mockWallpaperRepository =
            MockWallPaperRepository();
        when(mockWallpaperRepository.searchItems(query: {'q': 'sdaata'}))
            .thenReturn(List.empty());

        //Act
        final result =
            mockWallpaperRepository.searchItems(query: {'q': 'sdaata'});

        //Assert
        expect(result, List.empty());
      });
    }
  });
}
