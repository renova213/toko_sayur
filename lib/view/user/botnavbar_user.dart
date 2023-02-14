import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';

import '../../common/style/style.dart';
import '../general/profile/profile_screen.dart';
import 'home/user_home_screen.dart';

class BotNavBarUser extends StatefulWidget {
  const BotNavBarUser({super.key});

  @override
  State<BotNavBarUser> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<BotNavBarUser> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = const <Widget>[
    UserHomeScreen(),
    UserHomeScreen(),
    UserHomeScreen(),
    UserHomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Provider.of<ProductViewModel>(context, listen: false).getProducts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.secondaryColor,
        leading: const Icon(Icons.menu, color: AppColor.primaryColor),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColor.primaryColor),
          ),
        ],
        title: Text(
          'Market Place',
          style: AppFont.subtitle.copyWith(color: AppColor.secondaryTextColor),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.secondaryColor,
        selectedIconTheme: const IconThemeData(color: Colors.orange),
        unselectedIconTheme: const IconThemeData(color: AppColor.primaryColor),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_outline), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColor.secondaryTextColor,
        selectedItemColor: Colors.orange,
        unselectedLabelStyle:
            AppFont.smallText.copyWith(color: AppColor.secondaryTextColor),
        onTap: _onItemTapped,
      ),
    );
  }
}
