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
  test('Test root logger', () {
    Logger rootLogger = LogManager.getRootLogger();
    expect(rootLogger, equals(isNotNull));
    expect(rootLogger.name, equals('ROOT'));
    expect(rootLogger.parent, equals(isNull));
  });

  test('Test getlogger', () {
    Logger logger = LogManager.getLogger('test.log.manager');
    expect(logger, equals(isNotNull));
    expect(logger.name, equals('test.log.manager'));
    expect(logger.parent, equals(LogManager.getRootLogger()));

    Logger? check = LogManager.instances['test.log'];
    expect(check, equals(isNotNull));
    expect((check is ProvisionNode), equals(true));
    expect(check!.name, equals('test.log'));

    Logger? check2 = LogManager.instances['test'];
    expect(check2, equals(isNotNull));
    expect((check2 is ProvisionNode), equals(true));
    expect(check2!.name, equals('test'));

    check = LogManager.getLogger('test.log');
    expect(check, equals(isNotNull));
    expect((check is ProvisionNode), equals(false));
    expect(check.name, equals('test.log'));
    expect(check.parent, equals(isNotNull));

    check2 = LogManager.getLogger('test');
    expect(check2, equals(isNotNull));
    expect((check2 is ProvisionNode), equals(false));
    expect(check2.name, equals('test'));
    expect(check2.parent, equals(isNotNull));
  });
}
