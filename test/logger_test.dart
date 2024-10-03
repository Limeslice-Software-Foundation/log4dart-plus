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
  late Logger logger;

  setUpAll(() {
    appender = TestAppender(
        layout: SimpleLayout(), name: 'TestAppender', threshold: Level.debug);
  });

  setUp(() {
    appender.buffer.clear();
    logger = Logger(name: 'TestLogger', level: Level.info);
    logger.addAppender(appender);
  });

  test('Test add appender', () {
    bool expected = true;
    bool actual = logger.appenders.contains(appender);
    expect(actual, equals(expected));
  });

  test('Test log level methods', () {
    appender.buffer.clear();

    logger.trace('Trace message');
    logger.debug('Debug message');
    logger.info('Info message');
    logger.warn('Warn message');
    logger.error('Error message');
    logger.fatal('Fatal message');

    expect(
        appender.buffer.toString(),
        equals(
            'TestLogger: INFO - Info message\nTestLogger: WARN - Warn message\nTestLogger: ERROR - Error message\nTestLogger: FATAL - Fatal message\n'));
  });

  test('Test remove appenders', () {
    LogManager.quietMode(true);
    logger.removeAllAppenders();
    logger.info('Info message');
    String expected = '';
    String actual = appender.buffer.toString();
    expect(actual, equals(expected));
  });

  test('Test close logger', () {
    logger.info('Info message');
    logger.close();
    logger.warn('Warn message');
    String expected = 'TestLogger: INFO - Info message\n';
    String actual = appender.buffer.toString();
    expect(actual, equals(expected));
  });

  test('Test effective level', () {
    expect(logger.getEffectiveLevel(), equals(Level.info));

    Logger child = Logger(name: 'Child Logger', parent: logger);
    expect(child.getEffectiveLevel(), equals(Level.info));

    Logger empty = Logger(name: 'Empty Logger');
    expect(() => empty.getEffectiveLevel(), throwsA(TypeMatcher<Exception>()));
  });
}
