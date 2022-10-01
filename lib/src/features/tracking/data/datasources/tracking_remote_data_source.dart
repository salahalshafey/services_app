import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:services_app/src/features/tracking/data/models/tracking_info_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class TrackingRemoteDataSource {
  Stream<TrackingInfoModel> getTrackingLive(String orderId);
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
}

/*Map<String, dynamic> m = {
  'is_service_giver_sharing_location': false,
  'previous_locations': [
    {
      'heading': 55.654,
      'latitude': 30.811856,
      'time': Timestamp(1664569064, 494000000),
      'speed': 27.55687,
      'longitude': 30.684204
    }
  ],
  'last_seen_location': {
    'heading': 55.654,
    'latitude': 30.811856,
    'time': Timestamp(1664569064, 422000000),
    'speed': 27.55687,
    'longitude': 30.684204
  }
};*/
