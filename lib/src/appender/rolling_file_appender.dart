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

import 'package:log4dart_plus/log4dart_plus.dart';

/// RollingFileAppender appends logging events to a file and bacs kup the log files when they reach a certain size. 
/// File size is specified in bytes.
class RollingFileAppender extends Appender {
  /// Max file size in bytes.
  int maxFileSize = 10 * 1024 * 1024;

  /// The max number of backup files to keep.
  int maxBackupIndex = 1;

  /// The file to log to.
  late File file;

  /// Flag for appending to log files.
  bool appendFile;

  /// Create a new instance.
  RollingFileAppender(
      {required String fileName,
      super.layout,
      super.name,
      super.threshold,
      super.errorHandler,
      this.appendFile = true}) {
    file = File(fileName);
    file.createSync(recursive: true);
  }

  /// Roll the files over.
  void rollOver() {
    File target;
    File aFile;
    bool renameSucceeded = true;

    if (maxBackupIndex > 0) {
      aFile = File('${file.absolute.path}.$maxBackupIndex');
      if (aFile.existsSync()) {
        aFile.deleteSync();
        renameSucceeded = true;
      }

      for (int i = maxBackupIndex - 1; i >= 1 && renameSucceeded; i--) {
        aFile = File('${file.absolute.path}.$i');
        if (aFile.existsSync()) {
          int x = i + 1;
          target = File('${file.absolute.path}.$x');
          aFile.renameSync(target.absolute.path);
        }
      }

      if (renameSucceeded) {
        target = File('${file.absolute.path}.1');
        file.renameSync(target.absolute.path);
      }
    } else {
      // truncate file
      file.writeAsStringSync('');
    }
  }

  /// Write the given String to the file using the append mode.
  void _writeToFile(String str) {
    file.writeAsStringSync(str,
        mode: appendFile ? FileMode.append : FileMode.writeOnly);
  }

  @override
  void doAppend(LoggingEvent event) {
    _writeToFile(layout!.format(event));
    if (!layout!.ignoresException() && event.exception != null) {
      _writeToFile('Exception: ${event.exception}');
    }
    if (!layout!.ignoresException() && event.stackTrace != null) {
      _writeToFile('${event.stackTrace}');
    }

    if (file.lengthSync() > maxFileSize) {
      rollOver();
    }
  }
}
