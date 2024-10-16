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
import 'package:commons_config/commons_config.dart';
import 'package:log4dart_plus/log4dart_plus.dart';
import 'package:log4dart_plus/src/configuration/layout_factory.dart';
import 'package:test/test.dart';

void main() {
  late Configuration configuration;
  final String key = 'log4dart.appender';

  setUpAll(() {
    configuration = BaseConfiguration();
    configuration.setProperty('log4dart.appender.N.layout', 'NoExistLayout');
    configuration.setProperty('log4dart.appender.S.layout', 'SimpleLayout');
    configuration.setProperty('log4dart.appender.D.layout', 'DateLayout');
    configuration.setProperty('log4dart.appender.D.layout.pattern', 'yyyy-MM-dd HH:mm:ss');
    configuration.setProperty('log4dart.appender.P.layout', 'PatternLayout');
    configuration.setProperty('log4dart.appender.P.layout.pattern', '[%-5s] %d{yyyy-MM-dd HH:ss:mm} %% %.30l - %m%n');
  });

  test('Test create non existent layout', () {
    String name = 'N';
    Layout? actual =
        LayoutFactory.createLayout(configuration, '$key.$name.layout');
    expect(actual, equals(isNull));
  });

  test('Test create Simple layout', () {
    String name = 'S';
    Layout? actual =
        LayoutFactory.createLayout(configuration, '$key.$name.layout');
    expect(actual, equals(isNotNull));
    expect(actual is SimpleLayout, equals(true));
  });

  test('Test create Date layout', () {
    String name = 'D';
    Layout? actual =
        LayoutFactory.createLayout(configuration, '$key.$name.layout');
    expect(actual, equals(isNotNull));
    expect(actual is DateLayout, equals(true));
    DateLayout dl = actual as DateLayout;
    expect(dl.dateFormat!.pattern, equals('yyyy-MM-dd HH:mm:ss'));
  });

  test('Test create Pattern layout', () {
    String name = 'P';
    Layout? actual =
        LayoutFactory.createLayout(configuration, '$key.$name.layout');
    expect(actual, equals(isNotNull));
    expect(actual is PatternLayout, equals(true));
    PatternLayout pl = actual as PatternLayout;
    expect(pl.pattern, equals('[%-5s] %d{yyyy-MM-dd HH:ss:mm} %% %.30l - %m%n'));
  });
}
