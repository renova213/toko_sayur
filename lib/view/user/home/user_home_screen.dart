import 'package:flutter/material.dart';

import '../../../common/style/style.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User', style: AppFont.subtitle),
      ),
    );
  }
}
