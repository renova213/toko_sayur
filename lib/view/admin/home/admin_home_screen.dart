import 'package:flutter/material.dart';

import '../../../common/style/style.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin', style: AppFont.subtitle),
      ),
    );
  }
}
