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
import 'package:intl/intl.dart';
import 'package:log4dart_plus/log4dart_plus.dart';
import 'package:test/test.dart';

void main() {
  late Layout layout;

  setUpAll((){
    layout = DateLayout(dateFormat: DateFormat('yyyy-MM-dd HH:mm:ss'));
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

  test('Test format', () {
    LoggingEvent event = LoggingEvent(
        level: Level.debug,
        message: 'This is a debug message',
        loggerName: 'TestLogger');
    event.instant = DateTime.parse('1969-07-20 20:18:04Z');
    String expected = '1969-07-20 20:18:04 TestLogger: DEBUG - This is a debug message';
    String actual = layout.format(event);
    expect(actual, equals(expected));
  });
}
