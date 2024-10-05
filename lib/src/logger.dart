// Licensed to the Limeslice Software Foundation (LSF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The LSF licenses this file to You under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://limeslice.org/license.txt
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'appender/appender.dart';
import 'internal/loglog.dart';
import 'level.dart';
import 'logging_event.dart';

/// This is the central class in the log4dart_plus package.
/// Most logging operations, except configuration, are done through this class.
class Logger {
  /// Reference to the parent logger.
  Logger? parent;

  /// List of appenders for this logger.
  List<Appender> appenders;

  /// The level of this logger.
  Level? level;

  /// The name of this logger.
  String name;

  /// Create a new instance using the given name, level and parent.
  Logger({required this.name, this.level, this.parent}) : appenders = [];

  /// Return a String representation of this logger.
  @override
  String toString() {
    return '${runtimeType.toString()}{name: $name, level: $level, appenders: $appenders, parent: $parent}';
  }

  /// Close this logger and all appenders attached to it.
  Future<void> close() async {
    for (Appender appender in appenders) {
      await appender.close();
    }
  }

  /// Determine the effective level. Throws an exception if no logger in the
  /// hierarchy is found with a non null level.
  Level getEffectiveLevel() {
    for (Logger? c = this; c != null; c = c.parent) {
      if (c.level != null) {
        return c.level!;
      }
    }
    throw Exception('No logger found in hierarchy with non null level');
  }

  /// Add the given appender to this logger.
  void addAppender(Appender appender) {
    appenders.add(appender);
  }

  /// Remove all appenders from this logger.
  void removeAllAppenders() {
    appenders.clear();
  }

  /// Output the given logging event to the appenders.
  void _doLog(LoggingEvent event) {
    int writes = 0;
    for (Logger? c = this; c != null; c = c.parent) {
      writes += c._appendLoopOnAppenders(event);
    }
    if (writes <= 0) {
      emitNoAppenderWarning();
    }
  }

  int _appendLoopOnAppenders(LoggingEvent event) {
    int size = appenders.length;
    for (var appender in appenders) {
      appender.append(event);
    }
    return size;
  }

  /// Output the given logging message to the appenders attached to this logger.
  void log(
      Level level, String message, Exception? exception, StackTrace? trace) {
    _doLog(LoggingEvent(
        level: level,
        message: message,
        loggerName: name,
        exception: exception,
        stackTrace: trace));
  }

  /// Output a fatal level message to the appenders.
  void fatal(String message) {
    if (Level.fatal.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.fatal, message, null, null);
    }
  }

  /// Output an error level message to the appenders.
  void error(String message, [Exception? exception, StackTrace? stackTrace]) {
    if (Level.error.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.error, message, exception, stackTrace);
    }
  }

  /// Output a warning level message to the appenders.
  void warn(String message) {
    if (Level.warn.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.warn, message, null, null);
    }
  }

  /// Output an info level message to the appenders.
  void info(String message) {
    if (Level.info.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.info, message, null, null);
    }
  }

  /// Output a debug level message to the appenders.
  void debug(String message) {
    if (Level.debug.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.debug, message, null, null);
    }
  }

  /// Output a trace level message to the appenders.
  void trace(String message) {
    if (Level.trace.isGreaterOrEqual(getEffectiveLevel())) {
      log(Level.trace, message, null, null);
    }
  }

  /// Print a warning to the console if not appenders are attached to this
  /// logger and an attempt is made to output a logging event.
  void emitNoAppenderWarning() {
    LogLog.error('No appenders could be found for logger ($name)');
    LogLog.error('Please initialize the log4dart_plus system properly.');
  }
}
