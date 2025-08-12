# Wallinice - Flutter Wallpaper App

## Project Overview

Wallinice is a modern Flutter wallpaper application built with clean architecture principles, implementing best practices for performance, maintainability, and scalability. The project is based on the original [Wallify](https://github.com/Ethiel97/wallify) repository but modernized with improved architecture and patterns.

## Architecture & Design Patterns

### Clean Architecture Implementation
- **Feature-first organization** with clear separation of concerns
- **Domain-driven design** with entities, repositories, and use cases
- **Dependency inversion principle** - components depend on abstractions, not concretions
- **SOLID principles** applied throughout the codebase

### State Management
- **BLoC/Cubit pattern** with `flutter_bloc` for predictable state management
- **ValueWrapper pattern** for elegant state transitions and error handling
- **BlocSelector and listenWhen** for performance optimization to avoid unnecessary rebuilds
- **Custom extensions** for clean state transitions like `true.toSuccess<bool>()`

### Key Technologies
- **Dependency Injection**: GetIt + Injectable for compile-time DI configuration
- **Networking**: Retrofit + Dio with proper abstraction layers
- **Local Storage**: Hive with abstraction layer for easy testing and swapping
- **Navigation**: AutoRoute for type-safe, code-generated navigation
- **Firebase**: Authentication and backend services
- **Theme Management**: Dynamic theme switching with system/light/dark modes

## Project Structure

```
lib/
├── app/                          # Main app configuration
├── bootstrap.dart                # App initialization with Firebase and DI
├── core/                         # Core utilities and services
│   ├── constants/                # API endpoints and app constants
│   ├── di/                       # Dependency injection configuration
│   ├── errors/                   # Error handling models and exceptions
│   ├── network/                  # Network client abstractions
│   ├── storage/                  # Storage service abstractions
│   └── utils/                    # ValueWrapper and utility classes
├── features/                     # Feature modules (feature-first architecture)
│   ├── auth/                     # Authentication feature
│   ├── favorites/                # Favorites management
│   ├── main/                     # Main app navigation
│   ├── search/                   # Wallpaper search functionality
│   ├── settings/                 # App settings and theme management
│   ├── splash/                   # Splash screen with auth check
│   └── wallpapers/               # Core wallpaper functionality
├── shared/                       # Shared components and services
│   ├── routing/                  # AutoRoute configuration
│   ├── theme/                    # App theme and styling
│   ├── utils/                    # Shared utilities
│   └── widgets/                  # Reusable UI components
└── l10n/                         # Internationalization
```

### Feature Structure (Example: auth)
```
features/auth/
├── data/
│   ├── datasources/              # Remote and local data sources
│   ├── models/                   # Data transfer objects with JSON serialization
│   └── repositories/             # Repository implementations
├── domain/
│   ├── entities/                 # Business logic entities
│   └── repositories/             # Repository contracts
└── presentation/
    ├── cubit/                    # State management
    ├── pages/                    # Screen implementations
    └── widgets/                  # Feature-specific widgets
```

## Performance Optimizations

### State Management Performance
```dart
// ✅ Use BlocSelector for granular rebuilds
BlocSelector<WallpaperCubit, WallpaperState, List<Wallpaper>>(
  selector: (state) => state.wallpapers,
  builder: (context, wallpapers) => WallpaperGrid(wallpapers),
)

// ✅ Use listenWhen to control when listeners are triggered
BlocListener<AuthCubit, AuthState>(
  listenWhen: (previous, current) =>
      previous.authStatus.status != current.authStatus.status,
  listener: (context, state) => handleAuthStateChange(state),
)

// ✅ Use MediaQuery.sizeOf instead of full MediaQueryData
MediaQuery.sizeOf(context).height * 0.25
```

### ValueWrapper Pattern
```dart
// ✅ Elegant state transitions with extensions
emit(state.copyWith(downloadStatus: true.toSuccess<bool>()));
emit(state.copyWith(error: 'Network error'.toError<String>()));
emit(state.copyWith(loading: null.toLoading<bool>()));

// ✅ Clean state handling in UI
state.wallpapers.when(
  success: (wallpapers) => WallpaperGrid(wallpapers),
  error: (error, oldData) => ErrorWidget(error, retry: _retry),
  loading: (oldData) => oldData != null 
      ? WallpaperGrid(oldData) 
      : LoadingWidget(),
  initial: () => InitialWidget(),
)
```

## Dependency Injection Best Practices

### Abstractions Over Concretions
```dart
// ✅ Inject NetworkClient abstraction
@LazySingleton(as: WallpaperRemoteDataSource)
class PexelsRemoteDataSourceImpl implements WallpaperRemoteDataSource {
  PexelsRemoteDataSourceImpl(this._networkClient); // Not Dio directly
  final NetworkClient _networkClient;
}

// ✅ Storage service abstraction
@LazySingleton(as: StorageService)
class HiveStorageService implements StorageService {
  // Implementation can be easily swapped for testing or different storage solutions
}
```

### Generated DI Configuration
```dart
// Generated with build_runner
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

## Navigation with AutoRoute

### Type-safe Navigation
```dart
// ✅ Generated routes with parameters
@AutoRouteConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,
      path: RouteNames.splash,
      initial: true,
    ),
    AutoRoute(
      page: WallpapersByColorRoute.page,
      path: RouteNames.wallpapersByColor,
    ),
  ];
}

// ✅ Navigation with parameters
context.router.pushNamed(
  RouteNames.wallpapersByColor,
  pathParameters: {'colorHex': 'FF5733'},
);
```

## Error Handling Architecture

### Centralized Error Management
```dart
// ✅ Structured error details
class ErrorDetails extends Equatable {
  const ErrorDetails({
    required this.message,
    this.errorCode,
    this.stackTrace,
  });
}

// ✅ Repository-level error handling
@override
Future<List<Wallpaper>> getWallpapers() async {
  try {
    final response = await _networkClient.get('/wallpapers');
    return response.data.map((json) => WallpaperModel.fromJson(json)).toList();
  } on DioException catch (e) {
    throw NetworkException(e.message ?? 'Network error');
  } catch (e) {
    throw UnknownException(e.toString());
  }
}
```

## Firebase Integration

### Project Setup
- Firebase project: `wallinice`
- Configured platforms: Android, iOS
- Generated configuration: `lib/firebase_options.dart`

### Authentication Integration
```dart
// ✅ Firebase Auth with proper error handling
@LazySingleton(as: FirebaseAuthDatasource)
class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  FirebaseAuthDatasourceImpl(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }
}
```

## Theme Management

### Dynamic Theme Switching
```dart
// ✅ Settings cubit for theme management
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState()) {
    _loadThemeMode();
    _watchThemeMode();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    emit(state.copyWith(themeMode: null.toLoading<ThemeMode>()));
    try {
      await _repository.setThemeMode(themeMode);
      emit(state.copyWith(themeMode: themeMode.toSuccess<ThemeMode>()));
    } catch (e) {
      emit(state.copyWith(themeMode: 'Failed to update theme'.toError<ThemeMode>()));
    }
  }
}
```

## Development Commands

### Code Generation
```bash
# Generate all code (DI, serialization, routing)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch
```

### Firebase Configuration
```bash
# Configure Firebase (already done)
flutterfire configure --project=wallinice --platforms=android,ios
```

### Quality Assurance
```bash
# Run analysis
flutter analyze

# Run tests
flutter test

# Check for unused dependencies
flutter pub deps --dev
```

## API Integration

### Wallpaper Sources
- **Pexels API**: Primary source for high-quality wallpapers
- **Wallhaven API**: Secondary source for additional content
- **Repository pattern**: Combines both sources seamlessly

### Example API Implementation
```dart
@RestApi()
abstract class PexelsApiService {
  factory PexelsApiService(Dio dio) = _PexelsApiService;

  @GET('/search')
  Future<PexelsWallpaperResponse> searchWallpapers(
    @Query('query') String query,
    @Query('page') int page,
    @Query('per_page') int perPage,
  );

  @GET('/curated')
  Future<PexelsWallpaperResponse> getCuratedWallpapers(
    @Query('page') int page,
    @Query('per_page') int perPage,
  );
}
```

## Local Storage with Abstraction

### Storage Service Interface
```dart
abstract class StorageService {
  Future<void> put<T>(String collection, String key, T value);
  Future<T?> get<T>(String collection, String key);
  Future<List<T>> getAll<T>(String collection);
  Stream<List<T>> watch<T>(String collection);
  void dispose();
}
```

### Benefits of Abstraction
- Easy to test with mock implementations
- Can swap storage solutions (Hive → SQLite → SharedPreferences)
- Dependency inversion principle compliance
- Clean separation of concerns

## Widget Reusability

### Original Widget Usage
```dart
// ✅ Use original widgets from Wallify repo when available
WTextButton(
  onPress: () => _downloadWallpaper(),
  text: 'Download',
)

// ✅ Avoid unnecessary widget parceling
// Don't create micro-widgets for simple UI elements
```

### Performance-Optimized Widgets
```dart
// ✅ Stateless widgets with const constructors
class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    required this.wallpaper,
    this.height,
    super.key,
  });

  final Wallpaper wallpaper;
  final double? height;
}
```

## Testing Strategy (Pending Implementation)

### Recommended Testing Approach
- **Unit Tests**: Cubit/Repository logic with `bloc_test`
- **Widget Tests**: UI components with `flutter_test`
- **Integration Tests**: Full user flows
- **Mock Services**: Use `mocktail` for dependency mocking

## Best Practices Summary

### Code Organization
- ✅ Feature-first architecture over layer-first
- ✅ Clean architecture with clear boundaries
- ✅ Dependency injection with abstractions
- ✅ Consistent naming conventions

### Performance
- ✅ BlocSelector for granular rebuilds
- ✅ MediaQuery.sizeOf() over full MediaQueryData
- ✅ Const constructors and widgets
- ✅ Efficient list rendering with builders

### State Management
- ✅ ValueWrapper for elegant error handling
- ✅ Extensions for clean state transitions
- ✅ Proper cubit lifecycle management
- ✅ Immutable state objects

### UI/UX
- ✅ Responsive design with MediaQuery
- ✅ Hero animations for smooth transitions
- ✅ Loading states with old data preservation
- ✅ Proper error handling with retry mechanisms

## Environment Configuration

### Multi-Environment Setup
- **Development**: `main_development.dart`
- **Staging**: `main_staging.dart` 
- **Production**: `main_production.dart`

Each environment can have different:
- API endpoints
- Firebase configurations
- Debug settings
- App identifiers

## Deployment Considerations

### Android
- App bundle ID: `com.example.verygoodcore.nice.wall`
- Firebase Android app configured
- ProGuard rules for release builds

### iOS
- Bundle ID: `com.example.verygoodcore.nice-wall`
- Firebase iOS app configured
- App Store metadata and assets

This documentation serves as a comprehensive guide for understanding and maintaining the Nice Wall Flutter application, ensuring consistent development practices and architectural decisions.