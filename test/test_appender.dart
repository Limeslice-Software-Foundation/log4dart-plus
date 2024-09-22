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
import 'package:log4dart_plus/log4dart_plus.dart';

/// An appender implementation used for testing purposes.
class TestAppender extends Appender {
  /// A buffer to hold logging output.
  StringBuffer buffer;

  /// Create a new instance with an empty buffer.
  TestAppender({super.layout, super.name, super.threshold, super.errorHandler})
      : buffer = StringBuffer();

  @override
  void doAppend(LoggingEvent event) {
    buffer.writeln(layout!.format(event));
    if (!layout!.ignoresException() && event.exception != null) {
      buffer.writeln('Exception: ${event.message}');
      buffer.writeln(event.stackTrace);
    }
  }
}
