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
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  final GlobalKey<FormState> tripFormKeyA = GlobalKey<FormState>();
  final GlobalKey<FormState> tripFormKeyB = GlobalKey<FormState>();
  final GlobalKey<FormState> tripFormKeyC = GlobalKey<FormState>();

  var selectedTripDate = Rxn<DateTime>();
  var pageIndex = 0.obs;
  var selectedBilledTo = ''.obs;
  var selectedBusinessVertical = ''.obs;
  var selectedBilledVehicle = ''.obs;
  var selectedDriver = ''.obs;
  var selectedSource = ''.obs;
  var selectedConsignor = ''.obs;
  var selectedDestination = ''.obs;
  var selectedConsignee = Rxn<DocumentReference>().obs;
  var tripType = 'OS'.obs;
  var allVendors = <String>[].obs;
  var allVehicles = <String>[].obs;
  var allDrivers = <String>[].obs;
  var allSources = <String>[].obs;
  var allConsignors = <String>[].obs;
  var allDestination = <String>[].obs;
  var loggedInUserMobileNo = ''.obs;
  var customStages = <TripStage>[].obs;
  var isStagesInitialized = false.obs;

  RxInt currentStageIndex = 0.obs;

  void updateTripDate(DateTime date) {
    selectedTripDate.value = date;
  }

  void changePage(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String get formattedTripDate {
    if (selectedTripDate.value == null) return '';
    final date = selectedTripDate.value!;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  var allConsigneesMappedToConsignor = <Map<String, dynamic>>[].obs;
  Future<void> getConsigneesForSelectedConsignor() async {
    try {
      final querySnapshot = await _fireStore.collection('consignees').get();
      final consignees = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'consignee': data['consignee'] as String? ?? '',
          'consignor': data['consignor'] as String? ?? '',
          'area': data['area'] as String? ?? '',
          'reference': doc.reference,
        };
      }).toList();

      allConsigneesMappedToConsignor.value = consignees;
    } catch (e, st) {
      _handleError('Failed to fetch consignees', e);
    }
  }


  void initializeDefaultStages() {
    if (isStagesInitialized.value) return;

    final defaultStageData = [
      {'name': 'Vehicle Dock', 'icon': Icons.local_parking},
      {'name': 'Vehicle Loading', 'icon': Icons.upload},
      {'name': 'Dispatch', 'icon': Icons.local_shipping},
      {'name': 'Vechile Return', 'icon': Icons.home},
    ];

    customStages.clear();
    for (var stageData in defaultStageData) {
      final stage = TripStage(
        name: stageData['name'] as String,
        icon: stageData['icon'] as IconData,
        isCompleted: false,
        isExpanded: false,
      );
      customStages.add(stage);
    }

    isStagesInitialized.value = true;
  }

  final RxList<TripStage> stages = <TripStage>[
    TripStage(name: "Vehicle Dock", icon: Icons.upload),
    TripStage(name: "Vehicle Loading", icon: Icons.inventory),
    TripStage(name: "Dispatch", icon: Icons.local_shipping),
    TripStage(name: "Vehicle Return", icon: Icons.local_shipping),
  ].obs;

  bool get allStagesCompleted => stages.every((stage) => stage.isCompleted);

  int get nextIncompleteStageIndex {
    for (int i = 0; i < stages.length; i++) {
      if (!stages[i].isCompleted) return i;
    }
    return stages.length;
  }

  void toggleStageExpansion(int index) {
    if (index >= 0 && index < stages.length) {
      stages[index].isExpanded = !stages[index].isExpanded;
      stages.refresh();
    }
  }

  void updateStageNote(int index, String note) {
    if (index >= 0 && index < stages.length) {
      stages[index].note = note;
      stages.refresh();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await Future.wait([
        fetchDriversAndVehicles(),
        getUser(),
      ]);
    } catch (e) {
      _handleError('Initialization failed', e);
    }
  }

  Future<void> getUser() async {
    try {
      final mobileNo = await _storage.read('user_mobile_no');
      loggedInUserMobileNo.value = mobileNo ?? '';
    } catch (e) {
      _handleError('Failed to get user information', e);
    }
  }

  Future<void> fetchDriversAndVehicles() async {
    try {
      final futures = await Future.wait([
        _fireStore.collection('drivers').get(),
        _fireStore.collection('vehicles').get(),
        _fireStore.collection('destinations').get(),
        _fireStore.collection('sources').get(),
        _fireStore.collection('vendors').get(),
        _fireStore.collection('consignors').get(),
      ]);

      allDrivers.value = futures[0]
          .docs
          .map((doc) => doc.data()['driverName'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      allVehicles.value = futures[1]
          .docs
          .map((doc) => doc.data()['registrationNo'] as String? ?? '')
          .where((reg) => reg.isNotEmpty)
          .toList();

      allDestination.value = futures[2]
          .docs
          .map((doc) => doc.data()['destination'] as String? ?? '')
          .where((dest) => dest.isNotEmpty)
          .toList();

      allSources.value = futures[3]
          .docs
          .map((doc) => doc.data()['source'] as String? ?? '')
          .where((source) => source.isNotEmpty)
          .toList();

      allVendors.value = futures[4]
          .docs
          .map((doc) => doc.data()['vendor_name'] as String? ?? '')
          .where((vendor) => vendor.isNotEmpty)
          .toList();

      allConsignors.value = futures[5]
          .docs
          .map((doc) => doc.data()['consignor'] as String? ?? '')
          .where((consignor) => consignor.isNotEmpty)
          .toList();
    } catch (e) {
      _handleError('Failed to fetch dropdown data', e);
    }
  }

  Future<void> createTrip(TripModel trip) async {
    try {
      await _fireStore.collection('trips').add(trip.toMap());

      _showSuccessMessage("Trip Created", "Trip added successfully!");

      // Reset form data after successful creation
      _resetFormData();
    } catch (e) {
      _handleError('Failed to create trip', e);
    }
  }

  void _resetFormData() {
    selectedTripDate.value = null;
    selectedBilledTo.value = '';
    selectedBusinessVertical.value = '';
    selectedBilledVehicle.value = '';
    selectedDriver.value = '';
    selectedSource.value = '';
    selectedConsignor.value = '';
    selectedDestination.value = '';
    tripType.value = 'OS';
    allConsigneesMappedToConsignor.clear();
    pageIndex.value = 0;
  }

  // Method to clear form
  void clearTripForm() {
    selectedConsignor.value = '';
    selectedDestination.value = '';
    selectedSource.value = '';
    tripType.value = '';
  }

  Future<void> markTripStageDoneByCreatedAt(
      int index, DateTime createdAt) async {
    try {
      if (index < 0 || index >= stages.length) {
        _showErrorMessage("Invalid Action", "Invalid stage index");
        return;
      }

      final snapshot = await _fireStore
          .collection('trips')
          .where('created_at', isEqualTo: Timestamp.fromDate(createdAt))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _showErrorMessage(
            "Trip Not Found", "No trip found with the given timestamp");
        return;
      }

      final tripDoc = snapshot.docs.first;
      final tripId = tripDoc.id;
      final stagesData =
          List<Map<String, dynamic>>.from(tripDoc.data()['stages'] ?? []);

      final nextIndex =
          stagesData.indexWhere((s) => s['is_completed'] == false);
      if (index != nextIndex) {
        _showErrorMessage(
            "Invalid Action", "Please complete stages in sequential order");
        return;
      }

      stagesData[index]['is_completed'] = true;
      stagesData[index]['completed_at'] = Timestamp.now();

      final lastCompleted =
          stagesData.lastWhere((s) => s['is_completed'] == true);
      final currentStageName = lastCompleted['name'] ?? '';

      await _fireStore.collection('trips').doc(tripId).update({
        'stages': stagesData,
        'trip_status': currentStageName,
      });

      _showSuccessMessage(
          "Stage Completed", "Stage ${index + 1} marked as completed");
    } catch (e) {
      _handleError('Failed to mark stage as completed', e);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> tripStreamByCreatedAt(
      DateTime createdAt) {
    return _fireStore
        .collection('trips')
        .where('created_at', isEqualTo: Timestamp.fromDate(createdAt))
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  void completeTrip() {
    if (allStagesCompleted) {
      _showSuccessMessage("Trip Completed", "Trip completed successfully!");
      Get.offAllNamed('/dashboard');
    } else {
      _showErrorMessage("Incomplete Trip", "Please complete all stages first");
    }
  }

  bool validateStepOne() {
    return selectedTripDate.value != null &&
        selectedBilledTo.value.isNotEmpty &&
        selectedBilledVehicle.value.isNotEmpty;
  }

  bool validateStepTwo() {
    return selectedSource.value.isNotEmpty &&
        selectedConsignor.value.isNotEmpty &&
        selectedDestination.value.isNotEmpty &&
        tripType.value.isNotEmpty;
  }

  bool validateStepThree() {
    return selectedDriver.value.isNotEmpty &&
        selectedBusinessVertical.value.isNotEmpty;
  }

  void _handleError(String title, dynamic error) {
    print('[TripController Error] $title: $error');
    _showErrorMessage(title, "An error occurred. Please try again.");
  }

  void _showSuccessMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      margin: EdgeInsets.all(16.w),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      margin: EdgeInsets.all(16.w),
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
