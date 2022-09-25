import 'package:equatable/equatable.dart';

class Service extends Equatable {
  const Service({required this.id, required this.name, required this.image});

  final String id;
  final String name;
  final String image;

  @override
  List<Object?> get props => [id];
}
