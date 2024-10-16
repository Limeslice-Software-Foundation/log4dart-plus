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

import 'package:intl/intl.dart';

import 'layout.dart';
import '../logging_event.dart';

class PatternLayout extends Layout {
  /// Internal name of this layout.
  static const String layoutName = 'PatternLayout'; 

  /// Regular expression to match patterns.
  static final RegExp specifier = RegExp(
      r'%(?:(\d+)\$)?([\+\-\#0 ]*)(\d+|\*)?(?:\.(\d+|\*))?([a-z%])', caseSensitive: false);

  /// The pattern to use.
  String pattern;

  /// The format to use for dates.
  DateFormat dateFormat = DateFormat();

  /// Create a new pattern layout using the given pattern. 
  /// If no pattern is provided an empty string will be used.
  PatternLayout([this.pattern = '']);

  /// Formats the logging event printing the Level and the message.
  @override
  String format(LoggingEvent event) {
    String result = pattern;
    int offset = 0;
    for (var m in specifier.allMatches(pattern)) {
      //String? parameter = m[1]; // NOT  USED
      String flags = m[2]!;
      String? width = m[3];
      String? precision = m[4];
      String type = m[5]!;

      String replacement = '';
      int replaceEnd = m.end+offset;
      bool datePatternFound = false;
      switch(type) {
        case 's': {
          replacement = padAndTruncate(event.level.toString(), flags, width, precision);
          break;
        }
        case 'm': {
          replacement = padAndTruncate(event.message, flags, width, precision);
          break;
        }
        case 'l': {
          replacement = padAndTruncate(event.loggerName, flags, width, precision);
          break;
        }
        case 'd': {
          int start = result.indexOf('{', m.start);
          if(start==(m.end+offset)) {            
            int end = result.indexOf('}', start);
            if(end > start) {
              String pattern = result.substring(start+1,end);
              dateFormat = DateFormat(pattern);
              replaceEnd = end+1;
              datePatternFound = true;
            }
          }
          replacement = padAndTruncate(dateFormat.format(event.instant), flags, width, precision);
          break;
        }
        case 'n': {
          replacement = Platform.lineTerminator;
          break;
        }
        case '%': {
          replacement = '%';
          break;
        }
      }
      if(replacement.isNotEmpty) {
        result = result.replaceRange(m.start+offset, replaceEnd, replacement);
        if(datePatternFound) {
          offset -= 4;  // remove %d{}
        } else {
          offset += replacement.length-(m.end-m.start);
        }
      }
    }
    return result;
  }

  String padAndTruncate(String input, String? flags, String? width, String? precision) {
    String result = input;
    bool rightPad = false;
    int? w = int.tryParse(width??'');
    int? truncate = int.tryParse(precision??'');
    if(w!=null) {
      rightPad=(flags != null && flags.isNotEmpty && flags=='-');
      rightPad ? result=result.padRight(w): result=result.padLeft(w) ;
    }
    if(truncate!=null && result.length>truncate) {
      int index = result.length-truncate;
      result = result.substring(index);
    }
    return result;
  }

  /// Return a String representation of this SimpleLayout.
  @override
  String toString() {
    return '$layoutName{}';
  }    
}