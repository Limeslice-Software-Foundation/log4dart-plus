import '../internal/loglog.dart';
import 'error_handler.dart';

/// The OnlyOnceErrorHandler implements log4dart_plus default error handling
/// policy which consists of emitting a message for the first error in an
/// appender and ignoring all following errors.
class OnlyOnceErrorHandler extends ErrorHandler {
  // Keep track if this error has been handled.
  bool _firstTime = true;

  /// This method is invoked to handle the error.
  @override
  void error(String message, [Exception? ex]) {
    if (_firstTime) {
      LogLog.error(message, ex);
      _firstTime = false;
    }
  }

  /// Set the appender for which errors are handled.
  @override
  void setAppender(String appenderName) {}
}
