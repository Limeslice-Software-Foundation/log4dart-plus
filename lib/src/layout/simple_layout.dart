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

import 'layout.dart';
import '../logging_event.dart';

/// A very simple implementation of Layout.
class SimpleLayout extends Layout {
  /// Internal name of this layout.
  static const String layoutName = 'SimpleLayout';

  /// Formats the logging event printing the Logger name, the Level and the message.
  /// The format is as follows:
  /// <code>&lt;logger name&gt;: &lt;level&gt; - &lt;message&gt;</code>
  @override
  String format(LoggingEvent event) {
    return '${event.loggerName}: ${event.level.toString()} - ${event.message}';
  }

  /// Return a String representation of this SimpleLayout.
  @override
  String toString() {
    return '$layoutName{}';
  }
}
