import 'package:commons_config/commons_config.dart';

import '../layout/layout.dart';
import '../layout/simple_layout.dart';

class LayoutFactory {
  static Layout? createLayout(Configuration configuration, String prefixKey) {
    String name = configuration.getString(prefixKey);

    switch (name) {
      case SimpleLayout.layoutName:
        {
          return SimpleLayout();
        }
    }

    return null;
  }
}
