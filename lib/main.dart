import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:social_media_app/warpper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // เป็นแค่ตัวรันแอปทัง หมดจาก   Warpper
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Warpper(),
    );
  }
}

