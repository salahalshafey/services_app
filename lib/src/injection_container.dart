import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';

import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/orders/domain/repositories/orders_repository.dart';
import 'features/services/data/datasources/service_remote_data_source.dart';
import 'features/services/data/repositories/service_repository_impl.dart';
import 'features/services/domain/repositories/services_repository.dart';
import 'features/services/domain/usecases/get_all_sevices.dart';
import 'features/services/presentation/providers/services.dart';

import 'features/services_givers/data/datasources/service_giver_remote_data_source.dart';
import 'features/services_givers/data/repositories/service_givers_repository_impl.dart';
import 'features/services_givers/domain/repositories/service_givers_repository.dart';
import 'features/services_givers/domain/usecases/get_all_sevice_givers.dart';
import 'features/services_givers/presentation/providers/services_givers.dart';

import 'features/orders/data/datasources/order_remote_data_source.dart';
import 'features/orders/data/datasources/order_remote_storage.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/domain/usecases/add_order.dart';
import 'features/orders/domain/usecases/cancel_order.dart';
import 'features/orders/domain/usecases/get_all_user_orders.dart';
import 'features/orders/domain/usecases/remove_order.dart';
import 'features/orders/presentation/providers/orders.dart';

import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_remote_storage.dart';
import 'features/chat/data/datasources/maps_servcice.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/usecases/get_chat_with_one_time_read.dart';
import 'features/chat/domain/usecases/get_chat_with_real_time_changes.dart';
import 'features/chat/domain/usecases/send_file_message.dart';
import 'features/chat/domain/usecases/send_location_message.dart';
import 'features/chat/domain/usecases/send_text_message.dart';
import 'features/chat/presentation/providers/chat.dart';

final sl = GetIt.instance;

Future<void> init() async {
/////////////////////////////////////////////// !!!! Features - services !!!! /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Provider

  sl.registerFactory(() => Services(getAllServices: sl()));

// Usecases

  sl.registerLazySingleton(() => GetAllServicesUsecase(sl()));

// Repository

  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

// Datasources

  sl.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceFirestoreImpl());

////////////////////////////////////////// !!!! Features - service_givers !!!! ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Provider

  sl.registerFactory(() => ServicesGivers(getAllServiceGivers: sl()));

// Usecases

  sl.registerLazySingleton(() => GetAllServiceGiversUsecase(sl()));

// Repository

  sl.registerLazySingleton<ServiceGiversRepository>(
      () => ServiceGiversRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));

// Datasources

  sl.registerLazySingleton<ServiceGiverRemoteDataSource>(
      () => ServiceGiverFirestoreImpl());

////////////////////////////////////////////// !!!! Features - orders !!!! ////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Provider
  sl.registerFactory(() => Orders(
        getAllUserOrders: sl(),
        addUserOrder: sl(),
        canceUserOrder: sl(),
        removeOrder: sl(),
      ));

// Usecases

  sl.registerLazySingleton(() => GetAllUserOrdersUsecase(sl()));
  sl.registerLazySingleton(() => AddOrderUsecase(sl()));
  sl.registerLazySingleton(() => CancelOrderUsecase(sl()));
  sl.registerLazySingleton(() => RemoveOrderUsecase(sl()));

// Repository

  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(
        remoteDataSource: sl(),
        remoteStorage: sl(),
        networkInfo: sl(),
      ));

// Datasources

  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderFirestoreImpl());
  sl.registerLazySingleton<OrderRemoteStorage>(
      () => OrderFirebaseStorageImpl());

/////////////////////////////////////////////// !!!! Features - chat !!!! /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Provider

  sl.registerFactory(() => Chat(
        getChatStream: sl(),
        getChatOnce: sl(),
        sendUserTextMessage: sl(),
        sendUserFileMessage: sl(),
        sendUserLocationMessage: sl(),
      ));

// Usecases

  sl.registerLazySingleton(() => GetChatWithRealTimeChangesUsecase(sl()));
  sl.registerLazySingleton(() => GetChatWithOneTimeReadUsecase(sl()));
  sl.registerLazySingleton(() => SendTextMessageUsecase(sl()));
  sl.registerLazySingleton(() => SendFileMessageUsecase(sl()));
  sl.registerLazySingleton(() => SendLocationMessageUsecase(sl()));

// Repository

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        remoteDataSource: sl(),
        remoteStorage: sl(),
        mapsService: sl(),
        networkInfo: sl(),
      ));

// Datasources

  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatFirestoreImpl());
  sl.registerLazySingleton<ChatRemoteStorage>(() => ChatFirebaseStorageImpl());
  sl.registerLazySingleton<ChatMapsService>(() => ChatGoogleMapsImpl());

//////////////////////////////////////////////////// !!!! core !!!! ///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}
