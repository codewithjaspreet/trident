import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

  var tripType = 'OS'.obs;
  var allVendors = [].obs;
  var allVehicles = <String>[].obs;
  var allDrivers = <String>[].obs;
  var allSources = <String>[].obs;
  var allDestination = <String>[].obs;
  var loggedInUserMobileNo = ''.obs;


  final GlobalKey<FormState> tripFormKeyA = GlobalKey<FormState>();
  final GlobalKey<FormState> tripFormKeyB = GlobalKey<FormState>();

  void changePage(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getUser() async{

    loggedInUserMobileNo.value =  await GetStorage().read('user_mobile_no');
  }

  @override
  void onInit() {
    super.onInit();
    fetchDriversAndVehicles();
    getUser();
  }

  Future<void> createTrip(TripModel trip) async {
    await FirebaseFirestore.instance.collection('trips').add(trip.toMap());
    print("Trip created");
  }

  void updateTripDate(DateTime date) {
    selectedTripDate.value = '${date.day}/${date.month}/${date.year}';
  }

  Future<void> fetchDriversAndVehicles() async {
    final fireStore = FirebaseFirestore.instance;

    // Fetch Drivers
    final driverSnapshot = await fireStore.collection('drivers').get();
    final vehicleSnapshot = await fireStore.collection('vehicles').get();
    final destinationSnapshots = await fireStore.collection('destinations').get();
    final allSourcesSnapshots = await fireStore.collection('sources').get();

    allDrivers.value =
        driverSnapshot.docs.map((doc) => doc['driverName'] as String).toList();

    // Fetch Vehicles

    allVehicles.value = vehicleSnapshot.docs
        .map((doc) => doc['registrationNo'] as String)
        .toList();

    allDestination.value = destinationSnapshots.docs
        .map((doc) => doc['destination'] as String)
        .toList();

    allSources.value = allSourcesSnapshots.docs
        .map((doc) => doc['source'] as String)
        .toList();


  }
}
