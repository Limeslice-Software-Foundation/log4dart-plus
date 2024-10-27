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
import 'package:test/test.dart';

const String testLoggerName = 'ROOT';

void main() {
  File logFile = File('test/out/test.log');

  setUpAll(() async {
    bool exists = await logFile.exists();
    if (exists) {
      await logFile.delete();
    }
  });

  tearDownAll(() async {
    bool exists = await logFile.exists();
    if (exists) {
      await logFile.delete();
    }
    File file = File('${logFile.absolute.path}.1');
    exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    file = File('${logFile.absolute.path}.2');
    exists = await file.exists();
    if (exists) {
      await file.delete();
    }
  });

  void checkFileContent(String expectedContent) {
    String actualContent = logFile.readAsStringSync();
    expect(actualContent, equals(expectedContent));
  }

  test('Test rolling file appender', () async {
    RollingFileAppender appender = RollingFileAppender(
        fileName: logFile.path, layout: PatternLayout('[%-5s] %l - %m%n'));
    appender.maxBackupIndex = 2;
    appender.maxFileSize = 1024;
    LogManager.getRootLogger().addAppender(appender);

    for (int i = 0; i < 40; ++i) {
      LogManager.getRootLogger()
          .debug('This is a really long debug message: $i');
    }

    await LogManager.shutdown();

    expect(File(logFile.absolute.path).existsSync(), equals(true));
    expect(File('${logFile.absolute.path}.1').existsSync(), equals(true));
    expect(File('${logFile.absolute.path}.2').existsSync(), equals(true));

    checkFileContent(
        '[DEBUG] ROOT - This is a really long debug message: 38\n[DEBUG] ROOT - This is a really long debug message: 39\n');
  });
}
