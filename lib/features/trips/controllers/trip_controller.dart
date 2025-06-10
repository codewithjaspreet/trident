import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/models/trip_model.dart';

class TripController extends GetxController {
  final PageController pageController = PageController();

  // Page Controller Variables for mobile view
  var pageIndex = 0.obs;


  // Trip Creation Form Variables
  var selectedTripDate = ''.obs;
  var selectedBilledTo = ''.obs;
  var selectedBusinessVertical = ''.obs;
  var selectedBilledVehicle = ''.obs;
  var selectedDriver = ''.obs;
  var selectedSource = ''.obs;
  var selectedDestination = ''.obs;
  var dieselPrice = 0.0.obs;
  var totalTripChargesAllocated = 0.0.obs;
  var estimatedDistance = 0.0.obs;
  var tripFormKey = GlobalKey<FormState>();
  var tripType = 'OS'.obs;


  void changePage(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> createTrip(TripModel trip) async {
    await FirebaseFirestore.instance.collection('trips').add(trip.toMap());
    print("Trip created");
  }

  void updateTripDate(DateTime date) {
    selectedTripDate.value = '${date.day}/${date.month}/${date.year}';
  }

}
