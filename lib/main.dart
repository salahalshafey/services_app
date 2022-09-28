import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';

import 'src/injection_container.dart' as di;

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp();

  await di.init();

  runApp(const MyApp());
}
