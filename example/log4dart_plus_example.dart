import 'dart:io';

import 'package:log4dart_plus/log4dart_plus.dart';

void main() {
  LogConfigurator.doBasicConfiguration();
  Logger logger = LogManager.getLogger('example');
  logger.debug('This is a debug message');
}
