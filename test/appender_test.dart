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
import 'package:test/test.dart';

import 'test_appender.dart';

void main() {
  late TestAppender appender;

  setUp(() {
    appender = TestAppender(
        layout: SimpleLayout(), name: 'TestAppender', threshold: Level.debug);
  });

  test('Test requires layout', () {
    bool expected = true;
    bool actual = appender.requiresLayout();
    expect(actual, equals(expected));
  });

  test('Test severe as threshold', () {
    expect(appender.isAsSevereAsThreshold(Level.all), equals(false));
    expect(appender.isAsSevereAsThreshold(Level.error), equals(true));
  });

  test('Test append', () {
    appender.append(LoggingEvent(
        level: Level.debug,
        message: 'Debug Message',
        loggerName: 'TestLogger'));
    expect(appender.buffer.isNotEmpty, equals(true));
    expect(appender.buffer.toString(), equals('DEBUG - Debug Message\n'));

    appender.buffer.clear();
    appender.append(LoggingEvent(
        level: Level.fatal,
        message: 'Fatal Message',
        loggerName: 'TestLogger'));
    expect(appender.buffer.isNotEmpty, equals(true));
    expect(appender.buffer.toString(), equals('FATAL - Fatal Message\n'));
  });

  test('Test close', () {
    appender.append(LoggingEvent(
        level: Level.debug,
        message: 'Debug Message',
        loggerName: 'TestLogger'));
    expect(appender.buffer.isNotEmpty, equals(true));
    expect(appender.buffer.toString(), equals('DEBUG - Debug Message\n'));

    appender.close();
    expect(appender.closed, equals(true));
    appender.append(LoggingEvent(
        level: Level.fatal,
        message: 'Fatal Message',
        loggerName: 'TestLogger'));
    expect(appender.buffer.isNotEmpty, equals(true));
    expect(appender.buffer.toString(), equals('DEBUG - Debug Message\n'));
  });
}
