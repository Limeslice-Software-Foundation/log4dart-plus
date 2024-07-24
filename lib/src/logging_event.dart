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

/// The internal representation of logging events. When an affirmative decision
/// is made to log then a LoggingEvent instance is created. This instance is
/// passed around to the different Log4Dart Plus components.
class LoggingEvent {
  Level level;
  String message;
  DateTime instant;
  String loggerName;
  Exception? exception;
  StackTrace? stackTrace;

  LoggingEvent(
      {required this.level,
      required this.message,
      required this.loggerName,
      this.exception,
      this.stackTrace})
      : instant = DateTime.now();
}
