import 'package:logger/logger.dart';

class LogUtil {

  LogUtil._internal();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      stackTraceBeginIndex: 2,
      methodCount: 3,
    ),
  );

  /// 打印错误日志
  static void e(dynamic msg, {String? title}) {
    _printLog(Level.error, msg, title: title);
  }

  /// 打印调试日志
  static void v(dynamic msg, {String? title}) {
    _printLog(Level.verbose, msg, title: title);
  }

  static void d(dynamic msg, {String? title}) {
    _printLog(Level.debug, msg, title: title);
  }

  static void i(dynamic msg, {String? title}) {
    _printLog(Level.info, msg, title: title);
  }

  static void w(dynamic msg, {String? title}) {
    _printLog(Level.warning, msg, title: title);
  }

  static void _printLog(Level level, dynamic msg, {String? title}) {

    if(title != null) {
      msg = [
        "------------ $title ------------",
        msg,
      ];
    }

    _logger.log(level, msg);
  }
}
