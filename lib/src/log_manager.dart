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
import 'internal/loglog.dart';
import 'logger.dart';
import 'root_logger.dart';

/// Represents a temporary place holder logger in a logger hierarchy.
class ProvisionNode extends Logger {
  /// List of loggers.
  List<Logger> loggers;

  /// Create a new instance
  ProvisionNode({required super.name, Logger? logger}) : loggers = [] {
    if (logger != null) {
      loggers.add(logger);
    }
  }

  /// Add a logger.
  void addLogger(Logger logger) {
    loggers.add(logger);
  }
}

/// Use the LogManager class to retreive Logger instances
class LogManager {
  /// Reference to the root logger instance.
  static final RootLogger _rootLogger = RootLogger();

  /// Set of loggers that are being managed.
  static Map<String, Logger> instances = {};

  /// Get a named logger.
  static Logger getLogger(String name) {
    Logger? logger = instances[name];
    if (logger == null) {
      logger = Logger(name: name);
      instances.putIfAbsent(name, () => logger!);
      _updateParents(logger);
      return logger;
    } else if (logger is ProvisionNode) {
      Logger newLogger = Logger(name: name);
      instances.putIfAbsent(name, () => newLogger);
      _updateChildren(logger, newLogger);
      _updateParents(newLogger);
      return newLogger;
    } else {
      return logger;
    }
  }

  static void _updateParents(Logger logger) {
    String name = logger.name;
    int length = name.length;
    bool parentFound = false;

    // if name = "w.x.y.z", loop through "w.x.y", "w.x" and "w", but not "w.x.y.z"
    for (int i = name.lastIndexOf('.', length - 1);
        i >= 0;
        i = name.lastIndexOf('.', i - 1)) {
      String substr = name.substring(0, i);

      Logger? aLogger = instances[substr];
      if (aLogger == null) {
        ProvisionNode pn = ProvisionNode(name: substr, logger: logger);
        instances[substr] = pn;
      } else if (aLogger is ProvisionNode) {
        ProvisionNode pn = aLogger;
        pn.addLogger(logger);
      } else {
        parentFound = true;
        logger.parent = aLogger;
        break;
      }
    }

    if (!parentFound) {
      logger.parent = _rootLogger;
    }
  }

  static void _updateChildren(ProvisionNode node, Logger logger) {
    for (var l in node.loggers) {
      if (!l.parent!.name.startsWith(logger.name)) {
        logger.parent = l.parent;
        l.parent = logger;
      }
    }
  }

  /// Return the root logger.
  static Logger getRootLogger() {
    return _rootLogger;
  }

  /// Close all the loggers.
  static Future<void> shutdown() async {
    for (Logger logger in instances.values) {
      await logger.close();
    }
  }

  /// Enable outputting debug messages.
  static void debug(bool debug) {
    LogLog.setDebug(debug);
  }
}
