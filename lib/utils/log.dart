import 'package:logger/logger.dart';

class DebugUtils {
  static void info(dynamic message) {
    Logger().i(message);
  }
}

final _logInstance = Logger();
final logger = _logInstance;

// ignore: avoid_classes_with_only_static_members
class LogUtils {
  // static Logger get logger => _logInstance;
  static void log(dynamic message) {
    _logInstance.i(message);
  }

  static void error(dynamic message) {
    _logInstance.e(message);
  }
}
