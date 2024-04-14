import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'camera_screen_controller.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

void main() {
  Get.put(CameraScreenController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}