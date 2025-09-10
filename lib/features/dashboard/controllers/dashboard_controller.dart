import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/data/models/user_model.dart';
import 'package:trident/routes/routes.dart';

class DashBoardController extends GetxController {
  final allCreatedTrips = <TripModel>[].obs;
  final allReviewTrips = <TripModel>[].obs;

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
    isLoading.value = true;
    _loadInitialData();
    isLoading.value = false;
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    await _initializeDashboard();
    isLoading.value = false;
  }

  Future<void> _initializeDashboard() async {
    await getUserRole();

    print('Logged in user role: ${loggedInUser.value.userRole}');
    if (loggedInUser.value.userRole == 'driver') {
      await getAllDriverAssignedTrips();
    }
    else {

      await getAllCreatedTrips();
    }
  }

  Future<void> getUserRole() async {
    loggedInUser.value.userRole = _storage.read('user_role') ?? '';
    loggedInUser.value.userMobileNumber = _storage.read('user_mobile_no') ?? '';
  }

  void switchScreen(String screen) {
    currentScreen.value = screen;
    Get.offNamed(TRoutes.addTripsScreen);
  }

  Future<void> getAllCreatedTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber.trim();

    final formattedMobile = rawMobile.startsWith('+91') ? rawMobile : '+91$rawMobile';

    try {
      final snapshot = await _fireStore
          .collection('trips')
          .where('created_by', isEqualTo: formattedMobile )
          .get();

      allCreatedTrips.value = snapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });

    } catch (e) {
      print('Error fetching admin trips: $e');
    }
  }

  Future<void> getAllReviewingTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber.trim();
    final formattedMobile = rawMobile.startsWith('+91') ? rawMobile : '+91$rawMobile';

    try {
      // First, get all trips that are in review
      final snapshot = await _fireStore
          .collection('trips')
          .where('in_review', isEqualTo: true)
          .get();

      // Filter out the current user's trips in memory
      allReviewTrips.value = snapshot.docs
          .where((doc) {
        final data = doc.data();
        return data['created_by'] != formattedMobile;
      })
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });


    } catch (e) {
      print('Error fetching review trips: $e');
    }
  }

  Future<void> getAllDriverAssignedTrips() async {
    final rawMobile = loggedInUser.value.userMobileNumber.trim();
    final cleanMobile = _normalizeMobile(rawMobile);

    if (cleanMobile.isEmpty) return;

    try {
      final driverSnapshot = await _fireStore
          .collection('drivers')
          .where('mobileNo', isEqualTo: cleanMobile)
          .limit(1)
          .get();

      if (driverSnapshot.docs.isEmpty) return;

      final driverName =
      driverSnapshot.docs.first['driverName']?.toString().trim();
      if (driverName == null || driverName.isEmpty) return;

      final tripSnapshot = await _fireStore
          .collection('trips')
          .where('driver_name', isEqualTo: driverName)
          .where('in_review', isEqualTo: false)
          .get();



      allCreatedTrips.value = tripSnapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate); // latest first
        });

    } catch (_) {}
  }




  String _normalizeMobile(String number) {
    final digitsOnly = number.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length > 10
        ? digitsOnly.substring(digitsOnly.length - 10)
        : digitsOnly;
  }
}
