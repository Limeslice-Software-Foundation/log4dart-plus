import 'package:commons_config/commons_config.dart';

import '../appender/appender.dart';
import '../appender/console_appender.dart';
import '../appender/file_appender.dart';

class AppenderFactory {
  static Appender? createAppender(
      Configuration configuration, String key, String name) {
    String appenderType = configuration.getString(key);

    switch (appenderType) {
      case ConsoleAppender.appenderName:
        return ConsoleAppender(name: name);
      case FileAppender.appenderName:
        {
          String fileName = configuration.getString('$key.file');
          return FileAppender(fileName: fileName, name: name);
        }
    }
    return null;
  }
}
