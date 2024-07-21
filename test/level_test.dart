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
  group('Test equals', () {
    test('DEBUG should equals DEBUG', () {
      bool expected = true;
      bool actual = Level.debug.equals(Level.debug);
      expect(actual, equals(expected));
    });

    test('DEBUG should NOT equals INFO', () {
      bool expected = false;
      bool actual = Level.debug.equals(Level.info);
      expect(actual, equals(expected));
    });
  });

  group('Test greater than or equals', () {
    test('WARN is greater than or equals INFO', () {
      bool expected = true;
      bool actual = Level.warn.isGreaterOrEqual(Level.info);
      expect(actual, equals(expected));
    });

    test('INFO is greater than or equals INFO', () {
      bool expected = true;
      bool actual = Level.info.equals(Level.info);
      expect(actual, equals(expected));
    });

    test('DEBUG is NOT greater than or equals INFO', () {
      bool expected = false;
      bool actual = Level.debug.isGreaterOrEqual(Level.info);
      expect(actual, equals(expected));
    });
  });

  test('toString', () {
    expect(Level.off.toString(), equals('OFF'));
    expect(Level.fatal.toString(), equals('FATAL'));
    expect(Level.error.toString(), equals('ERROR'));
    expect(Level.warn.toString(), equals('WARN'));
    expect(Level.info.toString(), equals('INFO'));
    expect(Level.debug.toString(), equals('DEBUG'));
    expect(Level.trace.toString(), equals('TRACE'));
    expect(Level.all.toString(), equals('ALL'));
  });
}
