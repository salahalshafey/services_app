import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'features/orders/presentation/pages/current_orders_screen.dart';
import 'features/orders/presentation/pages/previous_orders_screen.dart';
import 'features/services/presentation/pages/services_screen.dart';

class MainScreen extends StatefulWidget {
  static const routName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final _color = Colors.white;
  final _controler = PageController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  static const List<Widget> _screenOptions = <Widget>[
    ServiceScreen(key: PageStorageKey('ServiceScreen')),
    PreviousOrdersScreen(key: PageStorageKey('PreviousOrdersScreen')),
    CurrentOrdersScreen(key: PageStorageKey('CurrentOrdersScreen')),
  ];

  void _onPageScrolled(int index) {
    _tabController.animateTo(index);
  }

  void _onBottomNavigationBarClicked(int index) {
    _controler.animateToPage(
      index,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _screenOptions,
        onPageChanged: _onPageScrolled,
        controller: _controler,
      ),
      bottomNavigationBar: ConvexAppBar(
        controller: _tabController,
        items: [
          TabItem(
            icon: Icon(Icons.home, color: _color),
            activeIcon: const Icon(Icons.home, size: 30),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(Icons.text_snippet, color: _color),
            activeIcon: const Icon(Icons.text_snippet, size: 30),
            title: 'Previous Orders',
          ),
          TabItem(
            icon: Icon(Icons.text_snippet_outlined, color: _color),
            activeIcon: const Icon(Icons.text_snippet_outlined, size: 30),
            title: 'Current Orders',
          ),
        ],
        onTap: _onBottomNavigationBarClicked,
        backgroundColor: Theme.of(context).primaryColor,
        color: _color,
      ),
    );
  }
}
