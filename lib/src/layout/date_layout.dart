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
import 'package:log4dart_plus/src/internal/loglog.dart';

import 'layout.dart';
import '../logging_event.dart';

/// Provides a layout that prints the logging event instant (DateTime) using a 
/// DateFormat. For information on date formatting see the documentation for 
/// the DateFormat class in the <a href="https://pub.dev/packages/intl">intl</a> 
/// package.
class DateLayout extends Layout {
  /// Internal name of this layout.
  static const String layoutName = 'DateLayout';

  /// The date format to use.
  DateFormat? dateFormat;

  /// Create a new instance.
  DateLayout({this.dateFormat});

  /// Formats the logging event printing the Level and the message.
  @override
  String format(LoggingEvent event) {
    if(dateFormat != null) {
      return '${dateFormat!.format(event.instant)} ${event.loggerName}: ${event.level.toString()} - ${event.message}';
    } else {
      LogLog.error('DateFormat is null.');
      return '';
    }
  }

  /// Return a String representation of this Layout.
  @override
  String toString() {
    return '$layoutName{}';
  }  
}