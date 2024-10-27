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
import 'dart:io';

import '../logging_event.dart';
import 'appender.dart';

/// Appends log messages to an IOSink.
class IOSinkAppender extends Appender {
  /// The IOSink to use
  late IOSink? iosink;

  /// Create a new instance with the given IOSink.
  IOSinkAppender(
      {this.iosink,
      super.layout,
      super.name,
      super.threshold,
      super.errorHandler});

  @override
  void doAppend(LoggingEvent event) {
    if (iosink != null) {
      iosink!.writeln(layout!.format(event));
      if (!layout!.ignoresException() && event.exception != null) {
        iosink!.writeln('Exception: ${event.exception}');
        iosink!.writeln(event.stackTrace);
      }
    }
  }

  @override
  bool requiresLayout() {
    return true;
  }

  @override
  Future<void> close() async {
    if (!super.closed && iosink != null) {
      await iosink!.close();
      super.closed = true;
      iosink = null;
    }
  }
}
