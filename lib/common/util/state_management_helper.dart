import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view_model/login_view_model.dart';
import 'package:toko_sayur/view_model/register_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

class StateManagementHelper {
  static providers(Widget widget) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: widget,
    );
  }
}
