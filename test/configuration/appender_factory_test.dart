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
import 'package:log4dart_plus/src/configuration/appender_factory.dart';
import 'package:test/test.dart';

void main() {
  late Configuration configuration;
  final String key = 'log4dart.appender';

  setUpAll(() {
    configuration = BaseConfiguration();
    configuration.setProperty('log4dart.appender.R', 'RollingFileAppender');
    configuration.setProperty('log4dart.appender.stdout', 'ConsoleAppender');
  });

  test('Test create non existent appender', () {
    String name = 'R';
    Appender? actual =
        AppenderFactory.createAppender(configuration, '$key.R', name);
    expect(actual, equals(isNull));
  });

  test('Test create appender', () {
    String name = 'stdout';
    Appender? actual =
        AppenderFactory.createAppender(configuration, '$key.stdout', name);
    expect(actual, equals(isNotNull));
    expect(actual is ConsoleAppender, equals(true));
    expect(actual!.name, equals(name));
  });
}
