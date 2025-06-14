import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/routes/routes.dart';

class DashBoardController extends GetxController {
  var allCreatedTrips = <TripModel>[].obs;

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

  @override
  void onInit() {

    // TODO: implement onInit
    super.onInit();
    getAllAdminCreatedTrips();
  }

  void getAllAdminCreatedTrips() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    final allTripsSnapShot = await fireStore.collection('trips').get();

    allCreatedTrips.value = allTripsSnapShot.docs
        .map((doc) => TripModel.fromJson(doc.data()))
        .toList();
  }


}
