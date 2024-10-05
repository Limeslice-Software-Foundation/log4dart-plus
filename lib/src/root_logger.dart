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

import 'level.dart';
import 'logger.dart';

/// The root of the logger hierarchy.
/// The root logger always exists and never has a parent.
class RootLogger extends Logger {
  /// Name of the root logger.
  static final String rootName = 'ROOT';

  /// Reference to the one and only root logger instance
  static final RootLogger _singleton = RootLogger._internal();

  /// Factory method to return the instance.
  factory RootLogger() {
    return _singleton;
  }

  /// Internal contructor that creates the instance.
  RootLogger._internal() : super(name: rootName) {
    super.level = Level.debug;
  }
}
