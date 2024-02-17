import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/util/builders/on_will_pop_dialog.dart';
import '../../orders/presentation/pages/current_orders_screen.dart';
import '../../orders/presentation/pages/previous_orders_screen.dart';
import '../../services/presentation/pages/services_screen.dart';

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
  int _currentPageIndex = 0;

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

  void _scrolleToPage(int index) {
    _tabController.animateTo(index);

    setState(() {
      _currentPageIndex = index;
    });
  }

  void _animateToPage(int index) {
    _controler.animateToPage(
      index,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        if (_currentPageIndex != 0) {
          _animateToPage(0);
          return;
        }

        // final navigator = Navigator.of(context);
        final shouldPop = await exitWillPopDialog(context);
        if (shouldPop) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          // navigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          children: _screenOptions,
          onPageChanged: _scrolleToPage,
          controller: _controler,
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.flip,
          controller: _tabController,
          items: [
            TabItem(
              icon: Icon(Icons.home, color: _color),
              activeIcon: Icon(Icons.home, size: 30, color: _color),
              title: 'Home',
            ),
            TabItem(
              icon: Icon(Icons.text_snippet, color: _color),
              activeIcon: Icon(Icons.text_snippet, size: 30, color: _color),
              title: 'Previous Orders',
            ),
            TabItem(
              icon: Icon(Icons.text_snippet_outlined, color: _color),
              activeIcon: Icon(
                Icons.text_snippet_outlined,
                size: 30,
                color: _color,
              ),
              title: 'Current Orders',
            ),
          ],
          onTap: _animateToPage,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).dialogBackgroundColor
              : Theme.of(context).primaryColor,
          color: _color,
        ),
      ),
    );
  }
}



//////////////////////////////////////////
///

