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

import 'package:commons_config/commons_config.dart';

import 'appender/console_appender.dart';
import 'configuration/configuration_loader.dart';
import 'layout/simple_layout.dart';
import 'log_manager.dart';

/// Utility class for performing configuration of the Log4Dart_plus system.
class LogConfigurator {
  /// Perform a basic configuration. This used SimpleLayout and ConsoleAppender.
  static void doBasicConfiguration() {
    LogManager.getRootLogger().addAppender(ConsoleAppender(
        layout: SimpleLayout(), name: ConsoleAppender.appenderName));
  }

  /// Configure the logging system reading the properties file at the given
  /// path.
  static void doPropertiesConfiguration(String path) {
    PropertiesConfiguration propertiesConfiguration =
        PropertiesConfiguration(file: File(path));
    propertiesConfiguration.load();
    configure(propertiesConfiguration);
  }

  /// Configure the logging system using the given configuration.
  static void configure(Configuration configuration) {
    ConfigurationLoader loader = ConfigurationLoader();
    loader.configureFromConfiguration(configuration);
  }
}
