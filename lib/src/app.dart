import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/my_theme.dart';
import 'features/account/presentation/pages/account_screen.dart';
import 'features/account/presentation/providers/account.dart';

import 'features/services/presentation/providers/services.dart';

import 'features/services_givers/presentation/pages/service_givers_screen.dart';
import 'features/services_givers/presentation/providers/services_givers.dart';

import 'features/orders/presentation/pages/current_order_details_screen.dart';
import 'features/orders/presentation/pages/previous_order_details_screen.dart';
import 'features/orders/presentation/pages/request_service_screen.dart';
import 'features/orders/presentation/providers/orders.dart';

import 'features/chat/presentation/providers/chat.dart';

import 'features/tracking/presentation/pages/tracking_info_screen.dart';
import 'features/tracking/presentation/pages/tracking_screen.dart';
import 'features/tracking/presentation/providers/tracking.dart';

import 'main_screen.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Color get _myPrimaryColor => Colors.blue[900]!;
  // Color get _mysecondaryColor => Colors.blue[700]!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => di.sl<Services>()),
        ChangeNotifierProvider(create: (ctx) => di.sl<ServicesGivers>()),
        ChangeNotifierProvider(create: (ctx) => di.sl<Orders>()),
        ChangeNotifierProvider(create: (ctx) => di.sl<Chat>()),
        ChangeNotifierProvider(create: (ctx) => di.sl<Tracking>()),
        ChangeNotifierProvider(create: (ctx) => Account()),
      ],
      child: Builder(
        builder: (newContext) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Services',
            theme: MyTheme.light(_myPrimaryColor, useMaterial3: false),
            darkTheme: MyTheme.dark(_myPrimaryColor, useMaterial3: true),
            themeMode: ThemeMode.dark,
            home: const MainScreen(),
            routes: {
              ServiceGiversScreen.routName: (ctx) =>
                  const ServiceGiversScreen(),
              RequestServiceScreen.routName: (ctx) =>
                  const RequestServiceScreen(),
              AccountScreen.routName: (ctx) => const AccountScreen(),
              PreviousOrderDetailScreen.routName: (ctx) =>
                  const PreviousOrderDetailScreen(),
              CurrentOrderDetailScreen.routName: (ctx) =>
                  const CurrentOrderDetailScreen(),
              TrackingScreen.routName: (ctx) => const TrackingScreen(),
              TrackingInfoScreen.routName: (context) =>
                  const TrackingInfoScreen(),
            },
          );
        },
      ),
    );
  }
}
