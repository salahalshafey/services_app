import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.serviceGiverId,
    required this.serviceGiverName,
    required this.serviceGiverImage,
    required this.serviceGiverPhoneNumber,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userPhoneNumber,
    required this.serviceName,
    required this.cost,
    required this.quantity,
    required this.description,
    required this.image,
    required this.date,
    required this.status,
    this.reasonIfCanceled,
    this.dateOfFinishedOrCanceled,
  });

  final String id;
  final String serviceGiverId;
  final String serviceGiverName;
  final String serviceGiverImage;
  final String serviceGiverPhoneNumber;
  final String userId;
  final String userName;
  final String userImage;
  final String userPhoneNumber;
  final String serviceName;
  final double cost;
  final int quantity;
  final String description;
  final String image;
  final DateTime date;
  final String status;
  final String? reasonIfCanceled;
  final DateTime? dateOfFinishedOrCanceled;

  @override
  List<Object?> get props => [id];

  Order copyWith({
    String? id,
    String? serviceGiverId,
    String? serviceGiverName,
    String? serviceGiverImage,
    String? serviceGiverPhoneNumber,
    String? userId,
    String? userName,
    String? userImage,
    String? userPhoneNumber,
    String? serviceName,
    double? cost,
    int? quantity,
    String? description,
    String? image,
    DateTime? date,
    String? status,
    String? reasonIfCanceled,
    DateTime? dateOfFinishedOrCanceled,
  }) =>
      Order(
        id: id ?? this.id,
        serviceGiverId: serviceGiverId ?? this.serviceGiverId,
        serviceGiverName: serviceGiverName ?? this.serviceGiverName,
        serviceGiverImage: serviceGiverImage ?? this.serviceGiverImage,
        serviceGiverPhoneNumber:
            serviceGiverPhoneNumber ?? this.serviceGiverPhoneNumber,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userImage: userImage ?? this.userImage,
        userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
        serviceName: serviceName ?? this.serviceName,
        cost: cost ?? this.cost,
        quantity: quantity ?? this.quantity,
        description: description ?? this.description,
        image: image ?? this.image,
        date: date ?? this.date,
        status: status ?? this.status,
        reasonIfCanceled: reasonIfCanceled ?? this.reasonIfCanceled,
        dateOfFinishedOrCanceled:
            dateOfFinishedOrCanceled ?? this.dateOfFinishedOrCanceled,
      );
}
