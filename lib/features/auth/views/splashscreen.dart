import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/features/auth/controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is ready and delay navigation till after build
    Future.microtask(() {
      debugPrint('[SplashScreen] Checking auth status...');
      final authController = Get.put(AuthController());
      authController.handleAppLaunch(); // Will navigate from here
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
