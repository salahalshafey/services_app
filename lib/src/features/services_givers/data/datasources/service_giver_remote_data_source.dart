import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/service_giver_model.dart';

abstract class ServiceGiverRemoteDataSource {
  Future<List<ServiceGiverModel>> getAllServiceGivers(String serviceId);
}

class ServiceGiverFirestoreImpl implements ServiceGiverRemoteDataSource {
  ServiceGiverFirestoreImpl();

  @override
  Future<List<ServiceGiverModel>> getAllServiceGivers(String serviceId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('services-givers')
          .where('services', arrayContains: serviceId)
          .get();

      return response.docs
          .map((document) => ServiceGiverModel.fromFirestore(document))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }
}
