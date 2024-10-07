import 'package:commons_config/commons_config.dart';

import '../appender/appender.dart';
import '../internal/loglog.dart';
import '../layout/layout.dart';
import '../level.dart';
import '../log_manager.dart';
import '../logger.dart';
import '../root_logger.dart';
import 'appender_factory.dart';
import 'layout_factory.dart';

class ConfigurationLoader {
  /// The prefix key for all loggers.
  static final String loggerPrefix = "log4dart.logger.";

  /// The prefix key for the root logger.
  static final String rootLoggerPrefix = "log4dart.rootLogger";

  /// The prefix key for all appenders.
  static final String appenderPrefix = "log4dart.appender.";

  /// Special level value signifying inherited behaviour. The current
  /// value of this string constant is <b>inherited</b>. {@link #NULL}
  /// is a synonym.
  static final String inheritedStr = "inherited";

  /// Special level signifying inherited behaviour.
  /// The current value of this string constant is <code>null</code>.
  static final String nullStr = "null";

  /// Registry holds references to appenders that have already been loaded.
  Map registry = {};

  /// Configure the logging system using the given configuration.
  void configureFromConfiguration(Configuration configuration) {
    _setupDebugLogging(configuration);
    _configureRootLogger(configuration);
    _configureLoggers(configuration);
  }

  /// Setup debugging as necessary using the given configuration.
  void _setupDebugLogging(Configuration configuration) {
    bool isDebug = configuration.getBool(LogLog.debugKey, false);
    LogLog.setDebug(isDebug);
  }

  /// Configure the root logger using the given configuration.
  void _configureRootLogger(Configuration configuration) {
    String value = configuration.getString(rootLoggerPrefix);
    if (value.isNotEmpty) {
      Logger root = LogManager.getRootLogger();
      _configureLogger(
          configuration, root, rootLoggerPrefix, RootLogger.rootName);
    } else {
      LogLog.debug('Could not find root logger information. Is this OK?');
    }
  }

  /// Configure loggers using the given configuration.
  void _configureLoggers(Configuration configuration) {
    Iterator<String> iter = configuration.getKeys();
    while (iter.moveNext()) {
      String key = iter.current;
      if (key.startsWith(loggerPrefix)) {
        String loggerName = key.substring(loggerPrefix.length);
        Logger logger = LogManager.getLogger(loggerName);
        _configureLogger(configuration, logger, key, loggerName);
      }
    }
  }

  /// Configure the logger using the given configuration.
  void _configureLogger(Configuration configuration, Logger logger,
      String configKey, String name) {
    List list = configuration.getList(configKey);

    if (list.isNotEmpty) {
      Iterator iter = list.iterator;
      if (!iter.moveNext()) return;

      String levelStr = iter.current;
      LogLog.debug("Level token is [$levelStr].");

      // If the level value is inherited, set category level value to
      // null. We also check that the user has not specified inherited for the
      // root category.
      if (inheritedStr == levelStr || nullStr == levelStr) {
        if (name == RootLogger.rootName) {
          LogLog.warn("The root logger cannot be set to null.");
        } else {
          logger.level = null;
        }
      } else {
        logger.level = Level.toLevel(levelStr, Level.debug);
      }
      LogLog.debug("Logger $name set to ${logger.level}");

      logger.appenders.clear();
      Appender? appender;
      String appenderName;
      while (iter.moveNext()) {
        appenderName = iter.current.trim();
        LogLog.debug("Parsing appender named \"$appenderName\".");
        appender = _parseAppender(configuration, appenderName);
        if (appender != null) {
          logger.addAppender(appender);
        }
      }
    }
  }

  /// Parse an appender using the given configuration.
  Appender? _parseAppender(Configuration configuration, String appenderName) {
    Appender? appender = registry[appenderName];
    if (appender != null) {
      LogLog.debug("Appender \"$appenderName\" was already parsed.");
      return appender;
    }

    // Appender was not previously initialized.
    String prefix = appenderPrefix + appenderName;
    String layoutPrefix = "$prefix.layout";
    String thresholdPrefix = "$prefix.threshold";

    appender =
        AppenderFactory.createAppender(configuration, prefix, appenderName);
    if (appender == null) {
      LogLog.error("Could not instantiate appender named \"$appenderName\".");
      return null;
    }
    appender.name = appenderName;
    if (appender.requiresLayout()) {
      Layout? layout = _parseLayout(configuration, layoutPrefix);
      if (layout != null) {
        appender.layout = layout;
      } else {
        LogLog.debug(
            "Appender \"$appenderName\" requires a layout but could not configure layout for it.");
      }
    }
    String levelStr = configuration.getString(thresholdPrefix, '');
    if (levelStr.isNotEmpty) {
      appender.threshold = Level.toLevel(levelStr, Level.debug);
    }

    registry[appenderName] = appender;
    return appender;
  }

  /// Parse a layout using the given configuration.
  Layout? _parseLayout(Configuration configuration, String layoutPrefix) {
    return LayoutFactory.createLayout(configuration, layoutPrefix);
  }
}
