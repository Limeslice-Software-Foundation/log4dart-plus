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
import '../error/error_handler.dart';
import '../layout/layout.dart';
import '../level.dart';
import '../logging_event.dart';

/// Strategy for outputting logging messages.
abstract class Appender {
  /// The layout to use when outputting logging messages.
  Layout? layout;

  /// The threshold to use.
  Level? threshold;

  /// The error handler to use.
  ErrorHandler? errorHandler;

  /// Whether this appender has been closed.
  bool closed;

  /// The name of this appender.
  String? name;

  /// Create a new instance.
  Appender({this.layout, this.name, this.threshold, this.errorHandler})
      : closed = false;

  /// Whether this appender requires a layout or not.
  bool requiresLayout() {
    return true;
  }

  /// Close this appender
  Future<void> close() async {
    closed = true;
  }

  /// Append the logging event.
  void doAppend(LoggingEvent event);

  /// Append the logging event.
  void append(LoggingEvent event) {
    if (!isAsSevereAsThreshold(event.level)) {
      return;
    }
    if (!closed) {
      doAppend(event);
    }
  }

  /// Utility method to check if the given level is above the threshold level
  /// configured for this appender.
  bool isAsSevereAsThreshold(Level level) {
    return threshold == null ? true : level.isGreaterOrEqual(threshold!);
  }

  /// Return a String representation of this appender.
  @override
  String toString() {
    return '${runtimeType.toString()}{layout: $layout, threshold: $threshold, errorHandler: $errorHandler, closed: $closed, name: $name}';
  }
}
