import 'package:commons_config/commons_config.dart';
import 'package:intl/intl.dart';

import '../layout/date_layout.dart';
import '../layout/layout.dart';
import '../layout/pattern_layout.dart';
import '../layout/simple_layout.dart';

/// Used to create Layouts from configuration.
class LayoutFactory {
  static Layout? createLayout(Configuration configuration, String prefixKey) {
    String name = configuration.getString(prefixKey);

    switch (name) {
      case SimpleLayout.layoutName:
        {
          return SimpleLayout();
        }
      case DateLayout.layoutName:
        {
          String pattern = configuration.getString('$prefixKey.pattern', '');
          DateFormat dateFormat =
              pattern.isEmpty ? DateFormat() : DateFormat(pattern);
          return DateLayout(dateFormat: dateFormat);
        }
      case PatternLayout.layoutName:
        {
          String pattern = configuration.getString('$prefixKey.pattern', '');
          return PatternLayout(pattern);
        }
    }

    return null;
  }
}
