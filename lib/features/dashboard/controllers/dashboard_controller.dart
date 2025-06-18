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

  var selectedLanguage = 'en'.obs;
  final currentScreen = 'dashboard'.obs;
  final userRole = 'driver'.obs;
  var isLoading = false.obs;

  final loggedInUser = UserModel(userRole: '', userMobileNumber: '').obs;

  @override
  void onInit() {
    super.onInit();
    print('[Controller] onInit called'); // <-- crucial
    isLoading.value = true;
    _loadInitialData();
    isLoading.value = false;
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    await _initializeDashboard();
    isLoading.value = false;
  }

  /// Main flow controller: ensures user role is loaded before loading trips
  Future<void> _initializeDashboard() async {
    await getUserRole();

    if (loggedInUser.value.userRole == 'driver') {
      print('This is driver');
      await getAllDriverAssignedTrips();
    } else {
      await getAllAdminCreatedTrips();
    }
  }

  /// Reads user role and mobile number from storage
  Future<void> getUserRole() async {
    loggedInUser.value.userRole = _storage.read('user_role') ?? '';
    loggedInUser.value.userMobileNumber = _storage.read('user_mobile_no') ?? '';
    print(
        '[User] Role: ${loggedInUser.value.userRole}, Mobile: ${loggedInUser.value.userMobileNumber}');
  }

  /// Switch the visible screen on desktop
  void switchScreen(String screen) {
    currentScreen.value = screen;
    Get.offNamed(TRoutes.addTripsScreen); // if you're always going to addTrips
  }

  /// Load trips for admin
  Future<void> getAllAdminCreatedTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber.trim();
    final formattedMobile = rawMobile.startsWith('+91') ? rawMobile : '+91$rawMobile';

    try {
      final snapshot = await _fireStore
          .collection('trips')
          .where('createdBy', isEqualTo: formattedMobile)
          .get();

      allCreatedTrips.value =
          snapshot.docs.map((doc) => TripModel.fromJson(doc.data())).toList();

      print('[Trips] Loaded ${allCreatedTrips.length} filtered admin trips');
    } catch (e) {
      print('[Trips] Error fetching filtered trips: $e');
    }
  }


  Future<void> getAllDriverAssignedTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber.trim();
    final cleanMobile = rawMobile.startsWith('+91')
        ? rawMobile.replaceFirst('+91', '')
        : rawMobile;

    print('[DriverTrips] Looking up trips for mobile: "$cleanMobile"');

    if (cleanMobile.isEmpty) {
      print('[DriverTrips] Error: Mobile number is empty.');
      return;
    }

    try {
      final driverSnapshot = await _fireStore
          .collection('drivers')
          .where('mobileNo', isEqualTo: cleanMobile)
          .limit(1)
          .get();

      if (driverSnapshot.docs.isEmpty) {
        print('[DriverTrips] No driver found with mobileNo: "$cleanMobile"');
        return;
      }

      final driverName =
          driverSnapshot.docs.first['driverName']?.toString().trim();
      if (driverName == null || driverName.isEmpty) {
        print('[DriverTrips] Error: Driver name is empty.');
        return;
      }

      final tripSnapshot = await _fireStore
          .collection('trips')
          .where('driverName', isEqualTo: driverName)
          .get();

      allCreatedTrips.value = tripSnapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList();

      print(
          '[DriverTrips] Loaded ${allCreatedTrips.length} trips for "$driverName"');
    } catch (e) {
      print('[DriverTrips] Failed to fetch trips: $e');
    }
  }
}
