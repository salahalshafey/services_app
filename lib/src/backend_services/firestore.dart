import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static Future<QuerySnapshot<Map<String, dynamic>>> getSrevices() =>
      FirebaseFirestore.instance.collection('services').get();

  static Future<QuerySnapshot<Map<String, dynamic>>> getSrevicesGivers(
          String serviceId) =>
      FirebaseFirestore.instance
          .collection('services-givers')
          .where('services', arrayContains: serviceId)
          .get();

  static Future<DocumentReference<Map<String, dynamic>>> addOrder(
          Map<String, dynamic> order) =>
      FirebaseFirestore.instance.collection('orders').add(order);

  static Future<void> updateImage(String docId, String newImage) =>
      FirebaseFirestore.instance
          .collection('orders')
          .doc(docId)
          .update({'image': newImage});

  static Future<void> deleteOrder(String orderId) =>
      FirebaseFirestore.instance.collection('orders').doc(orderId).delete();

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserOrders(
          String userId) =>
      FirebaseFirestore.instance
          .collection('orders')
          .where('user_id', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

  static Future<void> cancelOrder(
          String orderId, String reasonOfCancel, DateTime dateOfCancel) =>
      FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'canceled',
        'reason_if_canceled': reasonOfCancel,
        'date_of_finished_or_canceled': dateOfCancel
      });

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatRealTime(
      String orderId) async* {
    yield* FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .collection('chat')
        .orderBy('date', descending: true)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getChatOneTime(
          String orderId) =>
      FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .orderBy('date', descending: true)
          .get();

  static Future<DocumentReference<Map<String, dynamic>>> addMessage(
          String orderId, Map<String, dynamic> message) =>
      FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .add(message);
}
