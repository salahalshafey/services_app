import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getAllServices();
}

class ServiceFirestoreImpl implements ServiceRemoteDataSource {
  ServiceFirestoreImpl();

  @override
  Future<List<ServiceModel>> getAllServices() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection('services').get();

      return response.docs
          .map((document) => ServiceModel.fromFirestore(document))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }
}
