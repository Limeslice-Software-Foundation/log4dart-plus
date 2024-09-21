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

/// This class used to output log statements from within the log4dart_plus
/// package.
class LogLog {
  /// The quiet mode flag.
  static bool _quietMode = false;

  /// The debug mode flag.
  static bool _debugEnabled = false;

  /// The prefix to use for output statements.
  static final String prefix = "log4dart: ";

  /// The error prefix to use for output statements.
  static final String errPrefix = "log4dart:ERROR ";

  /// The warning prefix to use for output statements.
  static final String warnPrefix = "log4dart:WARN ";

  /// Set whether debug mode is enabled.
  static void setDebug(bool debug) {
    _debugEnabled = debug;
  }

  /// Set whether quiet mode is enabled.
  static void setQuiet(bool quiet) {
    _quietMode = quiet;
  }

  /// This method is used to output log4dart_plus internal debug statements.
  static void debug(String msg) {
    if (_debugEnabled && !_quietMode) {
      print(prefix + msg);
    }
  }

  /// This method is used to output log4dart_plus internal error statements.
  static void error(String msg, [Exception? ex, StackTrace? stack]) {
    if (_quietMode) return;
    print(errPrefix + msg);
    if (ex != null) {
      print(ex);
    }
    if (stack != null) {
      print(stack);
    }
  }
}
