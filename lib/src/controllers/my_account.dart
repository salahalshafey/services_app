import 'package:flutter/material.dart';

class MyAccount with ChangeNotifier {
  MyAccount();

  final String id = '1';
  final String name = 'Mohamed Alshafey';
  final String image = 'assets/images/salah1.jpeg';
  final double rating = 4;
  final String email = 'mohamedalshafey@gmail.com';
  final String phoneNumber = '01010730594';

  bool idIsMe(String id) => this.id == id;
}
