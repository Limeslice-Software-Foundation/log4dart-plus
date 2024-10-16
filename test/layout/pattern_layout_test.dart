
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

void main() {
  late PatternLayout layout;
  late LoggingEvent event;

  setUpAll((){
    layout = PatternLayout();
    event = LoggingEvent(
        level: Level.warn,
        message: 'This is a warn message',
        loggerName: 'AReallyLongLoggerName');
    event.instant = DateTime.parse('1969-07-20 20:18:04Z');
  });

  test('Test content type', () {
    String expected = 'text/plain';
    String actual = layout.getContentType();
    expect(actual, equals(expected));
  });

  test('Test header', () {
    String expected = '';
    String actual = layout.getHeader();
    expect(actual, equals(expected));
  });

  test('Test footer', () {
    String expected = '';
    String actual = layout.getFooter();
    expect(actual, equals(expected));
  });

  test('Test ignores exceptions', () {
    bool expected = true;
    bool actual = layout.ignoresException();
    expect(actual, equals(expected));
  });

  test('Test simple message format', () {
    layout.pattern = '%m';
    String expected = 'This is a warn message';
    String actual = layout.format(event);
    expect(actual, equals(expected));
  });

  test('Test escape % format', () {
    layout.pattern = '%% %m';
    expect(layout.format(event), equals('% This is a warn message'));
    layout.pattern = '%m%%';
    expect(layout.format(event), equals('This is a warn message%'));
  });

  test('Test complex message format', () {
    layout.pattern = '%s %d %l - %m%n';
    String expected = 'WARN July 20, 1969 8:18:04 PM AReallyLongLoggerName - This is a warn message\n';
    String actual = layout.format(event);
    expect(actual, equals(expected));
  });

  test('Test pad and truncate format', () {
    // Right padding
    layout.pattern = '[%-5s] %.20l - %m%n';
    String expected = '[WARN ] ReallyLongLoggerName - This is a warn message\n';
    expect(layout.format(event), equals(expected));

    // Let padding
    layout.pattern = '[%5s] %.20l - %m%n';
    expected = '[ WARN] ReallyLongLoggerName - This is a warn message\n';
    expect(layout.format(event), equals(expected));
  });

  test('Test date format', () {
    layout.pattern = '%d{yyyy-MM-dd HH:ss:mm}';
    expect(layout.format(event), equals('1969-07-20 20:04:18'));

    layout.pattern = '%s %d{yyyy-MM-dd HH:ss:mm} - %m';
    expect(layout.format(event), equals('WARN 1969-07-20 20:04:18 - This is a warn message'));

    layout.pattern = '[%-5s] %d{yyyy-MM-dd} %.20l - %m%n';
    expect(layout.format(event), equals('[WARN ] 1969-07-20 ReallyLongLoggerName - This is a warn message\n'));
  });

  test('Test full complex message format', () {
    layout.pattern = '[%-5s] %d{yyyy-MM-dd HH:ss:mm} %% %.20l - %m%n';
    String expected = '[WARN ] 1969-07-20 20:04:18 % ReallyLongLoggerName - This is a warn message\n';
    String actual = layout.format(event);
    expect(actual, equals(expected));
  });
}