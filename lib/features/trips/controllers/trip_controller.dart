import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/trip_model.dart';
import '../../dashboard/widgets/mobile/driver_trip_tracking.dart';

class TripController extends GetxController {
  final PageController pageController = PageController();
  final _fireStore = FirebaseFirestore.instance;

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
  var allVendors = <String>[].obs;
  var allVehicles = <String>[].obs;
  var allDrivers = <String>[].obs;
  var allSources = <String>[].obs;
  var allDestination = <String>[].obs;
  var loggedInUserMobileNo = ''.obs;


  // Trip Stages
  final RxList<TripStage> stages = <TripStage>[
    TripStage(name: "Loading", icon: Icons.upload),
    TripStage(name: "Loaded", icon: Icons.inventory),
    TripStage(name: "Dispatched", icon: Icons.local_shipping),
  ].obs;

  RxInt currentStageIndex = 0.obs;

  bool get allStagesCompleted => stages.every((stage) => stage.isCompleted);

  int get nextIncompleteStageIndex {
    for (int i = 0; i < stages.length; i++) {
      if (!stages[i].isCompleted) return i;
    }
    return stages.length;
  }

  void toggleStageExpansion(int index) {
    stages[index].isExpanded = !stages[index].isExpanded;
    stages.refresh();
  }
  Future<void> markTripStageDoneByCreatedAt(int index, DateTime createdAt) async {

    try {
      // Step 1: Fetch trip by createdAt timestamp
      final snapshot = await _fireStore
          .collection('trips')
          .where('created_at', isEqualTo: Timestamp.fromDate(createdAt))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print('[Error] No trip found with given createdAt');
        return;
      }

      final tripDoc = snapshot.docs.first;
      final tripId = tripDoc.id;
      final stages = List<Map<String, dynamic>>.from(tripDoc.data()['stages'] ?? []);

      if (index >= stages.length) {
        print('[Error] Invalid stage index');
        return;
      }

      final nextIndex = stages.indexWhere((s) => s['is_completed'] == false);
      if (index != nextIndex) {
        Get.snackbar(
          "Invalid Action",
          "Please complete stages in sequential order",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: EdgeInsets.all(16.w),
        );
        return;
      }

      // Step 2: Update selected stage
      stages[index]['is_completed'] = true;
      stages[index]['completed_at'] = Timestamp.now();

      // Step 3: Determine last completed stage name
      final lastCompleted = stages.lastWhere(
            (s) => s['is_completed'] == true,
      );

      final currentStageName = lastCompleted?['name'] ?? '';

      // Step 4: Update Firestore document
      await _fireStore.collection('trips').doc(tripId).update({
        'stages': stages,
        'trip_status': currentStageName,
      });

      print('[Success] Stage ${index + 1} marked as completed. Current stage: $currentStageName');
    } catch (e) {
      print('[Error] Failed to mark stage as done: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> tripStreamByCreatedAt(DateTime createdAt) {
    return FirebaseFirestore.instance
        .collection('trips')
        .where('created_at', isEqualTo: Timestamp.fromDate(createdAt))
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  void updateStageNote(int index, String note) {
    stages[index].note = note;
    stages.refresh();
  }

  void completeTrip() {
    if (allStagesCompleted) {
      Get.snackbar(
        "Success",
        "Trip completed successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: EdgeInsets.all(16.w),
      );
      Get.offAllNamed('/dashboard');
    }
  }


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
    Get.snackbar(
      "Done",
      "Trip added Successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      margin: EdgeInsets.all(16.w),
    );
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
    final allVendorsSnapshots = await fireStore.collection('vendors').get();

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


    allVendors.value = allVendorsSnapshots.docs
        .map((doc) => doc['vendor_name'] as String)
        .toList();

  }
}
