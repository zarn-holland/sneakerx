import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sneakerx/feature/pages/Order.dart';

import 'CartPage.dart';
import 'HomePage.dart';
import 'LikesPage.dart';
import 'ProfilePge.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _selectedIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    const HomePage(),
    const LikesPage(),
    const CartPage(),
    const OrderPage(),
    const ProfilePage()
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[300]!,
        color: Colors.grey,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _onPageChanged,
        items: const [
          Icon(Icons.home_rounded, size: 25,color: Color(0xFF222222),),
          Icon(Icons.favorite_border_outlined, size: 25,color: Color(0xFF222222)),
          Icon(Icons.add_shopping_cart, size: 25, color: Color(0xFF222222)),
          Icon(Icons.local_shipping, size: 25, color: Color(0xFF222222)),
          Icon(Icons.settings, size: 25,color: Color(0xFF222222))
        ],
      ),
    );
  }
}
