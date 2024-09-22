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

/// Appenders may delegate their error handling to ErrorHandlers.
/// Error handling is a particularly tedious to get right because by definition
/// errors are hard to predict and to reproduce.
abstract class ErrorHandler {
  /// This method is invoked to handle the error.
  void error(String message, [Exception? ex]);

  /// Set the appender for which errors are handled.
  void setAppender(String appenderName);
}
