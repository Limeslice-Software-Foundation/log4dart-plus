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

/// Levels used for identifying the severity of an event.
/// Levels are organized from most specific to least:
/// OFF - No event will be logged.
/// FATAL - A fatal event that will prevent the application from continuing.
/// ERROR -	An error in the application, possibly recoverable.
/// WARN - An event that might possible lead to an error.
/// INFO - An event for informational purposes.
/// DEBUG - A general debugging event.
/// TRACE - A fine-grained debug message, typically capturing the flow through
/// the application.
/// ALL - All events should be logged.
class Level {
  static final int _maxValue = double.maxFinite.toInt();
  static final int _minValue = -double.maxFinite.toInt();
  static final int _offValue = _maxValue;
  static final int _fatalValue = 60000;
  static final int _errorValue = 50000;
  static final int _warnValue = 40000;
  static final int _infoValue = 30000;
  static final int _debugValue = 20000;
  static final int _traceValue = 10000;
  static final int _allValue = _minValue;

  /// No events will be logged.
  static final Level off = Level(levelValue: _offValue, name: 'OFF');

  /// A fatal event that will prevent the application from continuing.
  static final Level fatal = Level(levelValue: _fatalValue, name: 'FATAL');

  /// An error in the application, possibly recoverable.
  static final Level error = Level(levelValue: _errorValue, name: 'ERROR');

  /// An event that might possible lead to an error.
  static final Level warn = Level(levelValue: _warnValue, name: 'WARN');

  /// An event for informational purposes.
  static final Level info = Level(levelValue: _infoValue, name: 'INFO');

  /// A general debugging event.
  static final Level debug = Level(levelValue: _debugValue, name: 'DEBUG');

  /// A fine-grained debug message, typically capturing the flow through the application.
  static final Level trace = Level(levelValue: _traceValue, name: 'TRACE');

  /// All events should be logged.
  static final Level all = Level(levelValue: _allValue, name: 'ALL');

  /// The int value of the level.
  int levelValue;

  /// The name of the level.
  String name;

  /// Create a new level with the given int value and name.
  Level({required this.levelValue, required this.name});

  /// Determine if this level is equal to the given level.
  bool equals(Level level) {
    return levelValue == level.levelValue;
  }

  /// Determine if this level is greater than or equal to the given level.
  bool isGreaterOrEqual(Level level) {
    return levelValue >= level.levelValue;
  }

  /// Parse the given string name to a Level. If an unknown level name is given
  /// then Level.all is returned.
  Level toLevel(String string) {
    switch (string.toLowerCase().trim()) {
      case 'off':
        return off;
      case 'fatal':
        return fatal;
      case 'error':
        return error;
      case 'warn':
        return warn;
      case 'info':
        return info;
      case 'debug':
        return debug;
      case 'trace':
        return trace;
    }
    return all;
  }

  /// Return the name of this level.
  @override
  String toString() {
    return name;
  }
}
