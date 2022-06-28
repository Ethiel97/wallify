import 'package:logger/logger.dart';

class DebugUtils {
  static void info(Object message) {
    Logger().i(message);
  }
}

final _logInstance = Logger();
final logger = _logInstance;

// ignore: avoid_classes_with_only_static_members
class LogUtils {
  // static Logger get logger => _logInstance;
  static void log(Object message) {
    _logInstance.i(message);
  }

  static void error(Object message) {
    _logInstance.e(message);
  }
}
