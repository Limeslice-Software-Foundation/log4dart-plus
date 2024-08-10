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
import '../logging_event.dart';

/// Responsible for formatting log messages. 
/// Extend this abstract class to create your own log layout format.
abstract class Layout {
  /// Format the given logging event into a String representation.
  String format(LoggingEvent event);

  /// Return the MIME content type of this layout.
  /// Default is test/plain
  String getContentType() {
    return 'text/plain';
  }

  /// Return the header for the layout.
  String getHeader() {
    return '';
  }

  /// Return the footer for the layout.
  String getFooter() {
    return '';
  }

  /// Returns true if the layout does not handle errors/exceptions, returns 
  /// true otherwise.
  bool ignoresException() {
    return true;
  }
}