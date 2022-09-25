import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel(
      {required String id, required String name, required String image})
      : super(id: id, name: name, image: image);

  factory ServiceModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return ServiceModel(
      id: document.id,
      name: document.data()['name'],
      image: document.data()['image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'image': image};
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
