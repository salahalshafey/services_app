import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/core/network/network_info.dart';
import 'package:services_app/src/features/account/presentation/pages/account_screen.dart';
import 'package:services_app/src/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:services_app/src/features/chat/data/datasources/chat_remote_storage.dart';
import 'package:services_app/src/features/chat/data/datasources/maps_servcice.dart';
import 'package:services_app/src/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:services_app/src/features/chat/domain/usecases/get_chat_with_one_time_read.dart';
import 'package:services_app/src/features/chat/presentation/providers/chat.dart';
import 'package:services_app/src/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:services_app/src/features/orders/data/datasources/order_remote_storage.dart';
import 'package:services_app/src/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:services_app/src/features/orders/domain/usecases/add_order.dart';
import 'package:services_app/src/features/orders/domain/usecases/cancel_order.dart';
import 'package:services_app/src/features/orders/domain/usecases/get_all_user_orders.dart';
import 'package:services_app/src/features/orders/domain/usecases/remove_order.dart';
import 'package:services_app/src/features/services/data/repositories/service_repository_impl.dart';
import 'package:services_app/src/features/services/domain/usecases/get_all_sevices.dart';
import 'package:services_app/src/features/services_givers/data/datasources/service_giver_remote_data_source.dart';

import 'features/account/presentation/providers/account.dart';
import 'features/chat/domain/usecases/get_chat_with_real_time_changes.dart';
import 'features/chat/domain/usecases/send_file_message.dart';
import 'features/chat/domain/usecases/send_location_message.dart';
import 'features/chat/domain/usecases/send_text_message.dart';
import 'features/orders/presentation/pages/current_order_details_screen.dart';
import 'features/orders/presentation/pages/previous_order_details_screen.dart';
import 'features/orders/presentation/pages/request_service_screen.dart';
import 'features/orders/presentation/providers/orders.dart';
import 'features/services/data/datasources/service_remote_data_source.dart';
import 'features/services/presentation/providers/services.dart';
import 'features/services_givers/data/repositories/service_givers_repository_impl.dart';
import 'features/services_givers/domain/usecases/get_all_sevice_givers.dart';
import 'features/services_givers/presentation/pages/service_givers_screen.dart';
import 'features/services_givers/presentation/providers/services_givers.dart';
import 'main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Color get _myPrimaryColor => Colors.blue[900]!;
  Color get _mysecondaryColor => Colors.blue[700]!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ////////////////////////////////////////////////////////////////////////////
        ////////// use get_it to handle dependency injection ///////////////////////
        ////////////////////////////////////////////////////////////////////////////
        ChangeNotifierProvider(
          create: (ctx) => Services(
            getAllServices: GetAllServicesUsecase(
              ServicesRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: ServiceFirestoreImpl(),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ServicesGivers(
            getAllServiceGivers: GetAllServiceGiversUsecase(
              ServiceGiversRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: ServiceGiverFirestoreImpl(),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(
            getAllUserOrders: GetAllUserOrdersUsecase(
              OrdersRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: OrderFirestoreImpl(),
                remoteStorage: OrderFirebaseStorageImpl(),
              ),
            ),
            addUserOrder: AddOrderUsecase(
              OrdersRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: OrderFirestoreImpl(),
                remoteStorage: OrderFirebaseStorageImpl(),
              ),
            ),
            canceUserOrder: CancelOrderUsecase(
              OrdersRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: OrderFirestoreImpl(),
                remoteStorage: OrderFirebaseStorageImpl(),
              ),
            ),
            removeOrder: RemoveOrderUsecase(
              OrdersRepositoryImpl(
                networkInfo: NetworkInfoImpl(),
                remoteDataSource: OrderFirestoreImpl(),
                remoteStorage: OrderFirebaseStorageImpl(),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Chat(
            getChatStream: GetChatWithRealTimeChangesUsecase(
              ChatRepositoryImpl(
                remoteDataSource: ChatFirestoreImpl(),
                remoteStorage: ChatFirebaseStorageImpl(),
                mapsService: GoogleMapsPlatform(),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            getChatOnce: GetChatWithOneTimeReadUsecase(
              ChatRepositoryImpl(
                remoteDataSource: ChatFirestoreImpl(),
                remoteStorage: ChatFirebaseStorageImpl(),
                mapsService: GoogleMapsPlatform(),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            sentUserTextMessage: SendTextMessageUsecase(
              ChatRepositoryImpl(
                remoteDataSource: ChatFirestoreImpl(),
                remoteStorage: ChatFirebaseStorageImpl(),
                mapsService: GoogleMapsPlatform(),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            sendUserFileMessage: SendFileMessageUsecase(
              ChatRepositoryImpl(
                remoteDataSource: ChatFirestoreImpl(),
                remoteStorage: ChatFirebaseStorageImpl(),
                mapsService: GoogleMapsPlatform(),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            sendUserLocationMessage: SendLocationMessageUsecase(
              ChatRepositoryImpl(
                remoteDataSource: ChatFirestoreImpl(),
                remoteStorage: ChatFirebaseStorageImpl(),
                mapsService: GoogleMapsPlatform(),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Account()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Services',
        theme: ThemeData(
          primaryColor: _myPrimaryColor,
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
        home: const MainScreen(),
        routes: {
          ServiceGiversScreen.routName: (ctx) => const ServiceGiversScreen(),
          RequestServiceScreen.routName: (ctx) => const RequestServiceScreen(),
          AccountScreen.routName: (ctx) => const AccountScreen(),
          PreviousOrderDetailScreen.routName: (ctx) =>
              const PreviousOrderDetailScreen(),
          CurrentOrderDetailScreen.routName: (ctx) =>
              const CurrentOrderDetailScreen(),
        },
      ),
    );
  }
}
