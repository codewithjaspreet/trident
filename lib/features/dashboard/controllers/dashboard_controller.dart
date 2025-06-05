import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {

  // Trip Creation Form Variables
  var selectedTripDate = ''.obs;
  var selectedBilledTo = ''.obs;
  var selectedBusinessVertical = ''.obs;
  var selectedBilledVehicle = ''.obs;
  var selectedDriver = ''.obs;
  var selectedSourceDestination = ''.obs;
  var selectedDestination = ''.obs;
  var dieselPrice = 0.0.obs;
  var totalTripChargesAllocated = 0.0.obs;
  var estimatedDistance = 0.0.obs;
  var tripFormKey = GlobalKey<FormState>();
  var tripType = 'OS'.obs;


  // Trip Creation Controller Variables

  var dieselPriceController = TextEditingController();
  var totalTripChargesAllocatedController = TextEditingController();
  var estimatedDistanceController = TextEditingController();

  // Page Controller Variables

  var pageController = PageController();
  var pageIndex = 0.obs;

  void updateTripDate(DateTime date) {
    selectedTripDate.value = '${date.day}/${date.month}/${date.year}';
  }

  void changePage(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
