import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: false,
  asExtension: true,
)
void configureDependencies() => getIt.init();
