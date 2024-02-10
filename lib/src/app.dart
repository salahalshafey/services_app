import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Color get _mysecondaryColor => Colors.blue[700]!;

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Services',
        theme: ThemeData(
          primaryColor: _myPrimaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: _myPrimaryColor),
          useMaterial3: false,
          secondaryHeaderColor: _mysecondaryColor,
          appBarTheme: AppBarTheme(
            color: _myPrimaryColor,
            /* shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),*/
          ),
          iconTheme: IconThemeData(color: _myPrimaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(_myPrimaryColor),
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                fontSize: 17,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(_myPrimaryColor),
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                fontSize: 17,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(_myPrimaryColor),
            ),
          ),
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: _myPrimaryColor),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _myPrimaryColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MainScreen(),
        routes: {
          ServiceGiversScreen.routName: (ctx) => const ServiceGiversScreen(),
          RequestServiceScreen.routName: (ctx) => const RequestServiceScreen(),
          AccountScreen.routName: (ctx) => const AccountScreen(),
          PreviousOrderDetailScreen.routName: (ctx) =>
              const PreviousOrderDetailScreen(),
          CurrentOrderDetailScreen.routName: (ctx) =>
              const CurrentOrderDetailScreen(),
          TrackingScreen.routName: (ctx) => const TrackingScreen(),
          TrackingInfoScreen.routName: (context) => const TrackingInfoScreen(),
        },
      ),
    );
  }
}
