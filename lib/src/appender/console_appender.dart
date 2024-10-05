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
import 'appender.dart';
import '../logging_event.dart';

/// ConsoleAppender appends log events to the console using a Dart's
/// <code>print</code> method.
class ConsoleAppender extends Appender {
  static const String appenderName = 'ConsoleAppender';

  /// Create a new appender using the given Layout.
  ConsoleAppender({super.layout, super.name});

  /// Append the logging event.
  @override
  void doAppend(LoggingEvent event) {
    print(layout!.format(event));
    if (!layout!.ignoresException() && event.exception != null) {
      print('Exception: ${event.message}');
      print(event.stackTrace);
    }
  }

  /// Whether this appender requires a layout or not. Returns true.
  @override
  bool requiresLayout() {
    return true;
  }
}
