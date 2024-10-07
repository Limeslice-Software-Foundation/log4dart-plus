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

  setUpAll(() {});

  tearDownAll(() async {
    bool exists = await logFile.exists();
    if (exists) {
      await logFile.delete();
    }
  });

  void checkFileContent(String expectedContent) {
    String actualContent = logFile.readAsStringSync();
    expect(actualContent, equals(expectedContent));
  }

  test('Test file appender', () async {
    FileAppender appender =
        FileAppender(fileName: logFile.path, layout: SimpleLayout());
    appender.append(LoggingEvent(
        level: Level.debug,
        message: 'A debug message',
        loggerName: testLoggerName));
    appender.append(LoggingEvent(
        level: Level.info,
        message: 'An info message',
        loggerName: testLoggerName));
    await appender.close();
    checkFileContent(
        'ROOT: DEBUG - A debug message\nROOT: INFO - An info message\n');
  });

  test('Test file appender append mode', () async {
    Appender appender = FileAppender(
        fileName: logFile.path,
        layout: SimpleLayout(),
        threshold: Level.error,
        append: true);
    appender.append(LoggingEvent(
        level: Level.debug,
        message: 'A debug message',
        loggerName: testLoggerName));
    appender.append(LoggingEvent(
        level: Level.error,
        message: 'An error message',
        loggerName: testLoggerName));
    await appender.close();
    checkFileContent(
        'ROOT: DEBUG - A debug message\nROOT: INFO - An info message\nROOT: ERROR - An error message\n');
  });
}
