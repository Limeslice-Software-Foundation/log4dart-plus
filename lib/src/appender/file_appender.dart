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

import 'iosink_appender.dart';

/// Appends log messages to a file.
class FileAppender extends IOSinkAppender {
  /// The name of this appender type.
  static const String appenderName = 'FileAppender';

  /// The file to append log messages to.
  late File file;

  /// Create a new instance, logging to the given file.
  FileAppender(
      {required String fileName,
      super.layout,
      super.name,
      super.threshold,
      super.errorHandler,
      bool append = false}) {
    file = File(fileName);
    file.createSync(recursive: true);
    super.iosink =
        file.openWrite(mode: append ? FileMode.append : FileMode.write);
  }
}
