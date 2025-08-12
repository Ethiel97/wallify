import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/settings/settings.dart';
import 'package:wallinice/l10n/l10n.dart';
import 'package:wallinice/shared/routing/routing.dart';
import 'package:wallinice/shared/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // Create router once to prevent navigation stack reset on theme changes
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsCubit>(
      future: _initializeSettingsCubit(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BlocProvider<SettingsCubit>.value(
            value: snapshot.data!,
            child: BlocSelector<SettingsCubit, SettingsState,
                ValueWrapper<ThemeMode>>(
              selector: (state) => state.themeMode,
              builder: (context, themeWrapper) => themeWrapper.maybeWhen(
                success: _buildMaterialApp,
                orElse: () => _buildMaterialApp(ThemeMode.system),
              ),
            ),
          );
        }

        // Show loading while initializing
        return _buildMaterialApp(ThemeMode.system);
      },
    );
  }

  Future<SettingsCubit> _initializeSettingsCubit() async {
    // Ensure SettingsLocalDataSource is ready before creating SettingsCubit
    await getIt.getAsync<SettingsLocalDataSource>();
    return getIt<SettingsCubit>();
  }

  Widget _buildMaterialApp(ThemeMode themeMode) {
    return MaterialApp.router(
      title: 'Wallinice',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
