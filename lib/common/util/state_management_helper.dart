import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StateManagementHelper {
  static providers(Widget widget) {
    return MultiProvider(
      providers: const [],
      child: widget,
    );
  }
}
