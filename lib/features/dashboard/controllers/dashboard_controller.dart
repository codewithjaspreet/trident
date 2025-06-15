import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/data/models/user_model.dart';
import 'package:trident/routes/routes.dart';

class DashBoardController extends GetxController {
  final allCreatedTrips = <TripModel>[].obs;

  // Trip Creation Controller Variables
  final dieselPriceController = TextEditingController();
  final totalTripChargesAllocatedController = TextEditingController();
  final estimatedDistanceController = TextEditingController();

  final _fireStore = FirebaseFirestore.instance;
  final _storage = GetStorage();

  final currentScreen = 'dashboard'.obs;
  var isLoading = false.obs;

  final loggedInUser = UserModel(userRole: '', userMobileNumber: '').obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDashboard();
  }

  /// Main flow controller: ensures user role is loaded before loading trips
  Future<void> _initializeDashboard() async {
    await getUserRole();

    if (loggedInUser.value.userRole == 'driver') {
      await getAllDriverAssignedTrips();
    } else {
      await getAllAdminCreatedTrips();
    }
  }

  /// Reads user role and mobile number from storage
  Future<void> getUserRole() async {
    loggedInUser.value.userRole = _storage.read('user_role') ?? '';
    loggedInUser.value.userMobileNumber = _storage.read('user_mobile_no') ?? '';
    debugPrint('[User] Role: ${loggedInUser.value.userRole}, Mobile: ${loggedInUser.value.userMobileNumber}');
  }

  /// Switch the visible screen on desktop
  void switchScreen(String screen) {
    currentScreen.value = screen;
    Get.offNamed(TRoutes.addTripsScreen); // if you're always going to addTrips
  }

  /// Load trips for admin
  Future<void> getAllAdminCreatedTrips() async {
    final snapshot = await _fireStore.collection('trips').get();

    allCreatedTrips.value = snapshot.docs
        .map((doc) => TripModel.fromJson(doc.data()))
        .toList();

    debugPrint('[Trips] Loaded ${allCreatedTrips.length} admin trips');
  }



  Future<void> getAllDriverAssignedTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber;

    if (rawMobile.isEmpty) {
      debugPrint('[Error] Driver mobile number not available. Cannot resolve driver.');
      return;
    }

    // Normalize to 10-digit number (if stored without country code in Firestore)
    final cleanMobile = rawMobile.startsWith('+91')
        ? rawMobile.replaceFirst('+91', '')
        : rawMobile;

    try {
      // Step 1: Get driver document using mobileNo
      final driverSnapshot = await _fireStore
          .collection('drivers')
          .where('mobileNo', isEqualTo: cleanMobile)
          .limit(1)
          .get();

      if (driverSnapshot.docs.isEmpty) {
        debugPrint('[Error] No driver found with mobileNo: $cleanMobile');
        return;
      }

      final driverDoc = driverSnapshot.docs.first;
      final driverName = driverDoc['name'];

      if (driverName == null || driverName.isEmpty) {
        debugPrint('[Error] Driver name is empty for mobileNo: $cleanMobile');
        return;
      }

      // Step 2: Get trips where driverName matches
      final tripSnapshot = await _fireStore
          .collection('trips')
          .where('driverName', isEqualTo: driverName)
          .get();

      allCreatedTrips.value = tripSnapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList();

      debugPrint('[Trips] Loaded ${allCreatedTrips.length} trips for driver: $driverName');
    } catch (e) {
      debugPrint('[Error] Failed to fetch driver trips: $e');
    }
  }



}
