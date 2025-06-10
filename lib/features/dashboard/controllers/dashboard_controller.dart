import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trident/routes/routes.dart';

class DashBoardController extends GetxController {



  // Trip Creation Controller Variables

  var dieselPriceController = TextEditingController();
  var totalTripChargesAllocatedController = TextEditingController();
  var estimatedDistanceController = TextEditingController();



  // switch body content for desktop

  var currentScreen = 'dashboard'.obs;

  void switchScreen(String screen) {
    currentScreen.value = screen;
    Get.offNamed(TRoutes.addTripsScreen);
  }



}
