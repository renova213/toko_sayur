import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view_model/admin_checkout_view_model.dart';
import 'package:toko_sayur/view_model/checkout_view_model.dart';
import 'package:toko_sayur/view_model/favorite_view_model.dart';
import 'package:toko_sayur/view_model/forgot_password_view_model.dart';
import 'package:toko_sayur/view_model/login_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/register_view_model.dart';
import 'package:toko_sayur/view_model/review_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../view_model/cart_view_model.dart';

class StateManagementHelper {
  static providers(Widget widget) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
        ChangeNotifierProvider(create: (_) => AdminCheckoutViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
      ],
      child: widget,
    );
  }
}
