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

/// A flexible layout configurable with pattern string.
///
/// <p>The goal of this class is to format a LoggingEvent and return the results
/// as a String. The result depends on the conversion pattern supplied.
/// The conversion pattern is similar to the print function in C. A conversion
/// pattern is composed of literal text and format control expressions called
/// conversion specifiers. You are free to insert any literal text within
/// the conversion pattern.</p>
///
/// <p>Each conversion specifier starts with a percent sign (%) and is
///followed by optional <em>format modifiers</em> and a <em>conversion
///character</em>. The conversion character specifies the type of
/// data, e.g. logger, severity, date and message. The format
/// modifiers control such things as field width, padding, left and
/// right justification. The following is a simple example.</p>
///
/// <p>Let the conversion pattern be <code>%-5s %l: %m%n</code> and assume
/// that the root logger uses an appender with PatternLayout. Then the
/// statements
/// <code>LogManager.getRootLogger().debug('This is a debug message!');</code>
/// will print out
/// <code>DEBUG ROOT: This is a debug message!</code></p>
///
/// <p>Of course you can create any pattern you wish using the following
/// conversion characters:</p>
///
/// <p><table>
/// <tr><td>d</td><td>Used to output the instant (DateTine) of the logging event.
/// The date conversion specifier may be followed by an optional date format
/// specifier enclosed between braces. The DateFormat class from the
/// <a href="https://pub.dev/packages/intl">intl</a> package is used - see this
/// class for more detail.</td></tr>
/// <tr><td>l</td><td>Used to output the name of the logger that triggered this
/// logging event.</td></tr>
/// <tr><td>m</td><td>Used to output the log message of the event.</td></tr>
/// <tr><td>n</td><td>Outputs the platform dependent line separator character or
/// characters.</td></tr>
/// <tr><td>s</td><td>Used to output the severity level of the event.</td></tr>
/// </table></p>
///
/// <p>By default the relevant information is output as is. However, with the
/// aid of format modifiers it is possible to change the minimum field width,
/// the maximum field width and justification. The optional format modifier
/// is placed between the percent sign and the conversion character.</p>
///
/// <p>The first optional format modifier is the left justification flag
/// which is just the minus (-) character. Then comes the optional minimum
/// field width modifier. This is a decimal constant that represents the
/// minimum number of characters to output. If the data item requires fewer
/// characters, it is padded on either the left or the right until the
/// minimum width is reached. The default is to pad on the left (right
/// justify) but you can specify right padding with the left justification
/// flag. The padding character is space. If the data item is larger than
/// the minimum field width, the field is expanded to accommodate the data.
/// The value is never truncated.</p>
///
/// <p>This behavior can be changed using the maximum field width modifier
/// which is designated by a period followed by a decimal constant. If the
/// data item is longer than the maximum field, then the extra characters
/// are removed from the beginning of the data item and not from the end.
/// For example, it the maximum field width is eight and the data item is
/// ten characters long, then the first two characters of the data item
/// are dropped. This behavior deviates from the printf function in C
/// where truncation is done from the end.</p>
///
/// <p>Below are various format modifier examples for the logger conversion
/// specifier.</p>
///
/// <p>
///  <TABLE BORDER=1 CELLPADDING=8>
///  <th>Format modifier
///  <th>left justify
///  <th>minimum width
///  <th>maximum width
///  <th>comment

///  <tr>
///  <td align=center>%20c</td>
///  <td align=center>false</td>
///  <td align=center>20</td>
///  <td align=center>none</td>

///  <td>Left pad with spaces if the category name is less than 20
///  characters long.

///  <tr> <td align=center>%-20c</td> <td align=center>true</td> <td
///  align=center>20</td> <td align=center>none</td> <td>Right pad with
///  spaces if the category name is less than 20 characters long.

///  <tr>
///  <td align=center>%.30c</td>
///  <td align=center>NA</td>
///  <td align=center>none</td>
///  <td align=center>30</td>

///  <td>Truncate from the beginning if the category name is longer than 30
///  characters.

///  <tr>
///  <td align=center>%20.30c</td>
///  <td align=center>false</td>
///  <td align=center>20</td>
///  <td align=center>30</td>

///  <td>Left pad with spaces if the category name is shorter than 20
///  characters. However, if category name is longer than 30 characters,
///  then truncate from the beginning.

///  <tr>
///  <td align=center>%-20.30c</td>
///  <td align=center>true</td>
///  <td align=center>20</td>
///  <td align=center>30</td>

///  <td>Right pad with spaces if the category name is shorter than 20
///  characters. However, if category name is longer than 30 characters,
///  then truncate from the beginning.

///  </table>

///  <p>Below are some examples of conversion patterns.</p>
///
/// <p><code>%s %l %m%n</code></p>
/// <p><code>[%-5s] %d{yyyy-MM-dd HH:ss:mm} %.30l - %m%n</code></p>
class PatternLayout extends Layout {
  /// Internal name of this layout.
  static const String layoutName = 'PatternLayout';

  /// Regular expression to match patterns.
  static final RegExp specifier = RegExp(
      r'%(?:(\d+)\$)?([\+\-\#0 ]*)(\d+|\*)?(?:\.(\d+|\*))?([a-z%])',
      caseSensitive: false);

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
      int replaceEnd = m.end + offset;
      bool datePatternFound = false;
      switch (type) {
        case 's':
          {
            replacement = _padAndTruncate(
                event.level.toString(), flags, width, precision);
            break;
          }
        case 'm':
          {
            replacement =
                _padAndTruncate(event.message, flags, width, precision);
            break;
          }
        case 'l':
          {
            replacement =
                _padAndTruncate(event.loggerName, flags, width, precision);
            break;
          }
        case 'd':
          {
            int start = result.indexOf('{', m.start);
            if (start == (m.end + offset)) {
              int end = result.indexOf('}', start);
              if (end > start) {
                String pattern = result.substring(start + 1, end);
                dateFormat = DateFormat(pattern);
                replaceEnd = end + 1;
                datePatternFound = true;
              }
            }
            replacement = _padAndTruncate(
                dateFormat.format(event.instant), flags, width, precision);
            break;
          }
        case 'n':
          {
            replacement = Platform.lineTerminator;
            break;
          }
        case '%':
          {
            replacement = '%';
            break;
          }
      }
      if (replacement.isNotEmpty) {
        result = result.replaceRange(m.start + offset, replaceEnd, replacement);
        if (datePatternFound) {
          offset -= 4; // remove %d{}
        } else {
          offset += replacement.length - (m.end - m.start);
        }
      }
    }
    return result;
  }

  /// Perform padding and truncation of the given input String as defined by
  /// the given flags, width and precision.
  String _padAndTruncate(
      String input, String? flags, String? width, String? precision) {
    String result = input;
    bool rightPad = false;
    int? w = int.tryParse(width ?? '');
    int? truncate = int.tryParse(precision ?? '');
    if (w != null) {
      rightPad = (flags != null && flags.isNotEmpty && flags == '-');
      rightPad ? result = result.padRight(w) : result = result.padLeft(w);
    }
    if (truncate != null && result.length > truncate) {
      int index = result.length - truncate;
      result = result.substring(index);
    }
    return result;
  }

  /// Return a String representation of this Layout.
  @override
  String toString() {
    return '$layoutName{}';
  }
}
