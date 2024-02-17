import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

import 'features/settings/pages/settings_screen.dart';
import 'features/settings/providers/app_settings.dart';
import 'features/tracking/presentation/pages/tracking_info_screen.dart';
import 'features/tracking/presentation/pages/tracking_screen.dart';
import 'features/tracking/presentation/providers/tracking.dart';

import 'features/main_and_drawer_screens/pages/main_screen.dart';
import 'injection_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ChangeNotifierProvider(create: (ctx) => AppSettings()),
      ],
      child: Builder(
        builder: (newContext) {
          final provider = Provider.of<AppSettings>(newContext);

          return MaterialApp(
            title: 'Services',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            themeMode: provider.themeMode,
            theme: MyTheme.light(
              provider.currentColor,
              useMaterial3: provider.useMaterial3,
            ),
            darkTheme: MyTheme.dark(
              provider.currentColor,
              useMaterial3: provider.useMaterial3,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: provider.currentLocal,
            home: const MainScreen(),
            routes: {
              SettingsScreen.routName: (ctx) => const SettingsScreen(),
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
