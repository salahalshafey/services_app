import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:services_app/src/features/tracking/data/models/tracking_info_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class TrackingRemoteDataSource {
  Stream<TrackingInfoModel> getTrackingLive(String orderId);
  Future<TrackingInfoModel> getTrackingOnce(String orderId);
}

class TrackingFirestoreImpl extends TrackingRemoteDataSource {
  @override
  Stream<TrackingInfoModel> getTrackingLive(String orderId) async* {
    try {
      final trackingStream = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('tracking')
          .doc(orderId)
          .snapshots();

      await for (final trackingDoc in trackingStream) {
        if (trackingDoc.exists && trackingDoc.data() != null) {
          yield TrackingInfoModel.fromJson(trackingDoc.data()!);
        } else {
          yield const TrackingInfoModel(
            isServiceGiverSharingLocation: false,
            lastSeenLocation: null,
            previousLocations: [],
          );
        }
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<TrackingInfoModel> getTrackingOnce(String orderId) async {
    try {
      final trackingDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('tracking')
          .doc(orderId)
          .get();

      if (trackingDoc.exists && trackingDoc.data() != null) {
        return TrackingInfoModel.fromJson(trackingDoc.data()!);
      } else {
        return const TrackingInfoModel(
          isServiceGiverSharingLocation: false,
          lastSeenLocation: null,
          previousLocations: [],
        );
      }
    } catch (error) {
      throw ServerException();
    }
  }
}
