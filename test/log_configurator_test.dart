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

const rootLoggerName = 'ROOT';

void main() {
  setUp(() async {
    LogManager.quietMode(true);
  });

  tearDown(() async {
    await LogManager.resetConfiguration();
    File logFile = File('example.log');
    bool exists = await logFile.exists();
    if (exists) {
      await logFile.delete();
    }
  });

  test('Test root logger - no configuration', () {
    Logger rootLogger = LogManager.getRootLogger();
    expect(rootLogger, equals(isNotNull));
    expect(rootLogger.name, equals(rootLoggerName));
    expect(rootLogger.parent, equals(isNull));
    expect(rootLogger.level, equals(isNotNull));
    expect(rootLogger.level, equals(Level.debug));
    expect(rootLogger.appenders, equals(isNotNull));
    expect(rootLogger.appenders, equals(isEmpty));
    expect(LogManager.instances, equals(isEmpty));
  });

  test('Test basic configuration', () {
    LogConfigurator.doBasicConfiguration();
    Logger rootLogger = LogManager.getRootLogger();
    expect(rootLogger, equals(isNotNull));
    expect(rootLogger.name, equals(rootLoggerName));
    expect(rootLogger.parent, equals(isNull));
    expect(rootLogger.level, equals(isNotNull));
    expect(rootLogger.level, equals(Level.debug));
    expect(rootLogger.appenders, equals(isNotNull));
    expect(rootLogger.appenders, equals(isNotEmpty));
    expect(rootLogger.appenders.length, equals(1));

    Appender appender = rootLogger.appenders[0];
    expect(appender is ConsoleAppender, equals(true));
    expect(appender.threshold, equals(isNull));
    expect(appender.errorHandler, equals(isNull));
    expect(appender.closed, equals(false));
    expect(appender.name, equals(ConsoleAppender.appenderName));
    expect(appender.layout, equals(isNotNull));
    expect(appender.layout is SimpleLayout, equals(true));

    expect(LogManager.instances, equals(isEmpty));
    Logger logger = LogManager.getLogger('test.logger');

    expect(LogManager.instances, equals(isNotEmpty));
    expect(LogManager.instances.length, equals(2));

    expect(logger.parent, equals(rootLogger));
    expect(logger.name, equals('test.logger'));
    expect(logger.level, equals(isNull));
    expect(logger.appenders, equals(isNotNull));
    expect(logger.appenders, equals(isEmpty));

    Object? o = LogManager.instances['test'];
    expect(o, equals(isNotNull));
    expect(o is ProvisionNode, equals(true));
    ProvisionNode provisionNode = o as ProvisionNode;
    expect(provisionNode.name, equals('test'));
    expect(provisionNode.parent, equals(isNull));
    expect(provisionNode.level, equals(isNull));
    expect(provisionNode.appenders, equals(isNotNull));
    expect(provisionNode.appenders, equals(isEmpty));
  });

  test('Test properties configuration', () {
    File file = File('test/log4dart.properties');
    LogConfigurator.doPropertiesConfiguration(file.path);

    Logger rootLogger = LogManager.getRootLogger();
    expect(rootLogger, equals(isNotNull));
    expect(rootLogger.name, equals(rootLoggerName));
    expect(rootLogger.parent, equals(isNull));
    expect(rootLogger.level, equals(isNotNull));
    expect(rootLogger.level, equals(Level.debug));
    expect(rootLogger.appenders, equals(isNotNull));
    expect(rootLogger.appenders, equals(isNotEmpty));
    expect(rootLogger.appenders.length, equals(2));

    Appender appender = rootLogger.appenders[0];
    expect(appender is ConsoleAppender, equals(true));
    expect(appender.threshold, equals(isNull));
    expect(appender.errorHandler, equals(isNull));
    expect(appender.closed, equals(false));
    expect(appender.name, equals('stdout'));
    expect(appender.layout, equals(isNotNull));
    expect(appender.layout is SimpleLayout, equals(true));

    appender = rootLogger.appenders[1];
    expect(appender is FileAppender, equals(true));
    expect(appender.threshold, equals(Level.info));
    expect(appender.errorHandler, equals(isNull));
    expect(appender.closed, equals(false));
    expect(appender.name, equals('F'));
    expect(appender.layout, equals(isNotNull));
    expect(appender.layout is SimpleLayout, equals(true));

    expect(LogManager.instances, equals(isNotEmpty));
    Logger logger = LogManager.getLogger('com.foo');
    expect(LogManager.instances, equals(isNotEmpty));
    expect(LogManager.instances.length, equals(2));

    expect(logger.parent, equals(rootLogger));
    expect(logger.name, equals('com.foo'));
    expect(logger.level, equals(Level.warn));
    expect(logger.appenders, equals(isNotNull));
    expect(logger.appenders, equals(isEmpty));

    Object? o = LogManager.instances['com'];
    expect(o, equals(isNotNull));
    expect(o is ProvisionNode, equals(true));
    ProvisionNode provisionNode = o as ProvisionNode;
    expect(provisionNode.name, equals('com'));
    expect(provisionNode.parent, equals(isNull));
    expect(provisionNode.level, equals(isNull));
    expect(provisionNode.appenders, equals(isNotNull));
    expect(provisionNode.appenders, equals(isEmpty));
  });
}
