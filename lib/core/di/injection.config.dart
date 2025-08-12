// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:wallinice/core/di/third_party_module.dart' as _i473;
import 'package:wallinice/core/network/dio_client.dart' as _i272;
import 'package:wallinice/core/network/dio_network_client.dart' as _i652;
import 'package:wallinice/core/network/network.dart' as _i686;
import 'package:wallinice/core/services/download_service.dart' as _i114;
import 'package:wallinice/core/services/services.dart' as _i901;
import 'package:wallinice/core/services/share_service.dart' as _i840;
import 'package:wallinice/core/storage/hive_storage_service.dart' as _i726;
import 'package:wallinice/core/storage/storage.dart' as _i309;
import 'package:wallinice/features/auth/auth.dart' as _i50;
import 'package:wallinice/features/auth/data/datasources/auth_local_datasource.dart'
    as _i757;
import 'package:wallinice/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i77;
import 'package:wallinice/features/auth/data/datasources/firebase_auth_datasource.dart'
    as _i612;
import 'package:wallinice/features/auth/data/repositories/auth_repository_impl.dart'
    as _i814;
import 'package:wallinice/features/auth/presentation/cubit/auth_cubit.dart'
    as _i1026;
import 'package:wallinice/features/favorites/data/datasources/favorites_local_datasource.dart'
    as _i96;
import 'package:wallinice/features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i154;
import 'package:wallinice/features/favorites/favorites.dart' as _i509;
import 'package:wallinice/features/favorites/presentation/cubit/favorites_cubit.dart'
    as _i888;
import 'package:wallinice/features/main/presentation/cubit/navigation_cubit.dart'
    as _i17;
import 'package:wallinice/features/search/presentation/cubit/search_cubit.dart'
    as _i926;
import 'package:wallinice/features/settings/data/datasources/settings_local_datasource.dart'
    as _i510;
import 'package:wallinice/features/settings/data/repositories/settings_repository_impl.dart'
    as _i635;
import 'package:wallinice/features/settings/presentation/cubit/settings_cubit.dart'
    as _i193;
import 'package:wallinice/features/settings/settings.dart' as _i154;
import 'package:wallinice/features/wallpapers/data/datasources/pexels_remote_datasource.dart'
    as _i1022;
import 'package:wallinice/features/wallpapers/data/datasources/wallhaven_remote_datasource.dart'
    as _i47;
import 'package:wallinice/features/wallpapers/data/repositories/wallpaper_repository_impl.dart'
    as _i367;
import 'package:wallinice/features/wallpapers/presentation/cubit/wallpaper_cubit.dart'
    as _i242;
import 'package:wallinice/features/wallpapers/presentation/cubit/wallpaper_detail_cubit.dart'
    as _i1;
import 'package:wallinice/features/wallpapers/wallpapers.dart' as _i823;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModule = _$ThirdPartyModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i17.NavigationCubit>(() => _i17.NavigationCubit());
    gh.lazySingleton<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => thirdPartyModule.flutterSecureStorage);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i686.NetworkClient>(
        () => _i652.DioNetworkClient(gh<_i361.Dio>()));
    gh.lazySingletonAsync<_i309.StorageService>(
      () {
        final i = _i726.HiveStorageService();
        return i.initialize().then((_) => i);
      },
      dispose: (i) => i.dispose(),
    );
    gh.lazySingletonAsync<_i96.FavoritesLocalDataSource>(() async =>
        _i96.FavoritesLocalDataSourceImpl(
            await getAsync<_i309.StorageService>()));
    gh.lazySingleton<_i840.ShareService>(
        () => _i840.ShareServiceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i114.DownloadService>(
        () => _i114.DownloadServiceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i757.AuthLocalDataSource>(
        () => _i757.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingletonAsync<_i509.FavoritesRepository>(() async =>
        _i154.FavoritesRepositoryImpl(
            await getAsync<_i509.FavoritesLocalDataSource>()));
    gh.lazySingleton<_i77.AuthRemoteDataSource>(
        () => _i77.AuthRemoteDataSourceImpl(gh<_i686.NetworkClient>()));
    gh.lazySingleton<_i612.FirebaseAuthDatasource>(
        () => _i612.FirebaseAuthDatasourceImpl(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i1022.PexelsRemoteDataSource>(
        () => _i1022.PexelsRemoteDataSourceImpl(gh<_i686.NetworkClient>()));
    gh.lazySingleton<_i47.WallhavenRemoteDataSource>(
        () => _i47.WallhavenRemoteDataSourceImpl(gh<_i686.NetworkClient>()));
    gh.factoryAsync<_i888.FavoritesCubit>(() async =>
        _i888.FavoritesCubit(await getAsync<_i509.FavoritesRepository>()));
    gh.lazySingleton<_i50.AuthRepository>(() => _i814.AuthRepositoryImpl(
          gh<_i50.AuthRemoteDataSource>(),
          gh<_i50.FirebaseAuthDatasource>(),
          gh<_i50.AuthLocalDataSource>(),
        ));
    gh.factory<_i1026.AuthCubit>(
        () => _i1026.AuthCubit(gh<_i50.AuthRepository>()));
    gh.lazySingletonAsync<_i510.SettingsLocalDataSource>(
      () async => _i510.SettingsLocalDataSourceImpl(
          await getAsync<_i309.StorageService>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i823.WallpaperRepository>(
        () => _i367.WallpaperRepositoryImpl(
              gh<_i823.PexelsRemoteDataSource>(),
              gh<_i823.WallhavenRemoteDataSource>(),
              gh<_i901.DownloadService>(),
              gh<_i901.ShareService>(),
            ));
    gh.factory<_i1.WallpaperDetailCubit>(
        () => _i1.WallpaperDetailCubit(gh<_i823.WallpaperRepository>()));
    gh.factory<_i242.WallpaperCubit>(
        () => _i242.WallpaperCubit(gh<_i823.WallpaperRepository>()));
    gh.factory<_i926.SearchCubit>(
        () => _i926.SearchCubit(gh<_i823.WallpaperRepository>()));
    gh.lazySingleton<_i154.SettingsRepository>(() =>
        _i635.SettingsRepositoryImpl(gh<_i154.SettingsLocalDataSource>()));
    gh.factory<_i193.SettingsCubit>(
        () => _i193.SettingsCubit(gh<_i154.SettingsRepository>()));
    return this;
  }
}

class _$ThirdPartyModule extends _i473.ThirdPartyModule {}

class _$NetworkModule extends _i272.NetworkModule {}
