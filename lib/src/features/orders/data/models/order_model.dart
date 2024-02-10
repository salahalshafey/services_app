import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order.dart' as order;

class OrderModel extends order.Order {
  const OrderModel({
    required String id,
    required String serviceGiverId,
    required String serviceGiverName,
    required String serviceGiverImage,
    required String serviceGiverPhoneNumber,
    required String userId,
    required String userName,
    required String userImage,
    required String userPhoneNumber,
    required String serviceName,
    required double cost,
    required int quantity,
    required String description,
    required String image,
    required DateTime date,
    required String status,
    String? reasonIfCanceled,
    DateTime? dateOfFinishedOrCanceled,
  }) : super(
          id: id,
          serviceGiverId: serviceGiverId,
          serviceGiverName: serviceGiverName,
          serviceGiverImage: serviceGiverImage,
          serviceGiverPhoneNumber: serviceGiverPhoneNumber,
          userId: userId,
          userName: userName,
          userImage: userImage,
          userPhoneNumber: userPhoneNumber,
          serviceName: serviceName,
          cost: cost,
          quantity: quantity,
          description: description,
          image: image,
          date: date,
          status: status,
          reasonIfCanceled: reasonIfCanceled,
          dateOfFinishedOrCanceled: dateOfFinishedOrCanceled,
        );

  factory OrderModel.fromOrder(order.Order order) {
    return OrderModel(
      id: order.id,
      serviceGiverId: order.serviceGiverId,
      serviceGiverName: order.serviceGiverName,
      serviceGiverImage: order.serviceGiverImage,
      serviceGiverPhoneNumber: order.serviceGiverPhoneNumber,
      userId: order.userId,
      userName: order.userName,
      userImage: order.userImage,
      userPhoneNumber: order.userPhoneNumber,
      serviceName: order.serviceName,
      cost: order.cost,
      quantity: order.quantity,
      description: order.description,
      image: order.image,
      date: order.date,
      status: order.status,
      reasonIfCanceled: order.reasonIfCanceled,
      dateOfFinishedOrCanceled: order.dateOfFinishedOrCanceled,
    );
  }

  factory OrderModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return OrderModel(
      id: document.id,
      serviceGiverId: document.data()['service_giver_id'],
      serviceGiverName: document.data()['service_giver_name'],
      serviceGiverImage: document.data()['service_giver_image'],
      serviceGiverPhoneNumber: document.data()['service_giver_phone_number'],
      userId: document.data()['user_id'],
      userName: document.data()['user_name'],
      userImage: document.data()['user_image'],
      userPhoneNumber: document.data()['user_phone_number'],
      serviceName: document.data()['service_name'],
      cost: (document.data()['cost'] as num).toDouble(),
      quantity: (document.data()['quantity'] as num).toInt(),
      description: document.data()['description'],
      image: document.data()['image'],
      date: (document.data()['date'] as Timestamp).toDate(),
      status: document.data()['status'],
      reasonIfCanceled: document.data()['reason_if_canceled'],
      dateOfFinishedOrCanceled:
          (document.data()['date_of_finished_or_canceled'] as Timestamp?)
              ?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'service_giver_id': serviceGiverId,
        'service_giver_name': serviceGiverName,
        'service_giver_image': serviceGiverImage,
        'service_giver_phone_number': serviceGiverPhoneNumber,
        'user_id': userId,
        'user_name': userName,
        'user_image': userImage,
        'user_phone_number': userPhoneNumber,
        'service_name': serviceName,
        'cost': cost,
        'quantity': quantity,
        'description': description,
        'image': image,
        'date': date,
        'status': status,
        'reason_if_canceled': reasonIfCanceled,
        'date_of_finished_or_canceled': dateOfFinishedOrCanceled,
      };
}
