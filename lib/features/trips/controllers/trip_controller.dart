
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/features/dashboard/views/navigation_bar.dart';
import '../../../data/models/trip_model.dart';
import '../../dashboard/widgets/mobile/driver_trip_tracking.dart';

class TripController extends GetxController {
  final PageController pageController = PageController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  final GlobalKey<FormState> tripFormKeyA = GlobalKey<FormState>();
  final GlobalKey<FormState> tripFormKeyB = GlobalKey<FormState>();
  final GlobalKey<FormState> tripFormKeyC = GlobalKey<FormState>();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  var selectedTripDate = Rxn<DateTime>();
  var pageIndex = 0.obs;
  var selectedBilledTo = ''.obs;
  var selectedBusinessVertical = ''.obs;
  var selectedBilledVehicle = ''.obs;
  var selectedDriver = ''.obs;
  var selectedSource = ''.obs;
  var selectedConsignor = ''.obs;
  var selectedDestination = ''.obs;
  var selectedConsignee = Rxn<DocumentReference>();
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
  var allTridentAuthorizers = <String>[].obs;

  // Edit mode states
  var isEditMode = false.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isApproving = false.obs;
  var originalTrip = Rxn<TripModel>();

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
      {'name': 'In Review', 'icon': Icons.rate_review},
      {'name': 'Open', 'icon': Icons.open_in_browser},
      {'name': 'Vehicle Dock', 'icon': Icons.local_parking},
      {'name': 'Vehicle Loading', 'icon': Icons.upload},
      {'name': 'Dispatch', 'icon': Icons.local_shipping},
      {'name': 'Vechile Return', 'icon': Icons.home},
      {'name': 'Completed', 'icon': Icons.check_circle_outline},
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
        _fireStore.collection('users').get(),
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

      allTridentAuthorizers.value = futures[6].docs
          .where((doc) => doc.data()['role'] == 'Trip Manager')
          .map((doc) => doc.data()['mobile'] as String ?? '')
          .toList();

      print(allTridentAuthorizers);

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
    isEditMode.value = false;
    originalTrip.value = null;
  }

  // Method to clear form
  void clearTripForm() {
    selectedConsignor.value = '';
    selectedDestination.value = '';
    selectedSource.value = '';
    tripType.value = '';
  }

  // ================== EDIT FUNCTIONALITY ==================

  /// Initialize edit form with trip data
  void initializeEditForm(TripModel trip) {
    originalTrip.value = trip;
    isEditMode.value = true;

    // Populate editable fields
    selectedTripDate.value = trip.tripDate;
    selectedBilledTo.value = trip.billedTo;
    selectedBilledVehicle.value = trip.billedVehicle;
    selectedDriver.value = trip.driverName;
    selectedSource.value = trip.source;
    selectedConsignor.value = trip.consignor ?? '';
    selectedDestination.value = trip.destination;
    tripType.value = trip.tripType;

    // Load consignees for the selected consignor
    if (selectedConsignor.value.isNotEmpty) {
      getConsigneesForSelectedConsignor();
    }
  }

  /// Validate edit form
  bool validateEditForm() {
    if (!editFormKey.currentState!.validate()) return false;

    return selectedTripDate.value != null &&
        selectedBilledTo.value.isNotEmpty &&
        selectedBilledVehicle.value.isNotEmpty &&
        selectedDriver.value.isNotEmpty &&
        selectedSource.value.isNotEmpty &&
        selectedConsignor.value.isNotEmpty &&
        selectedDestination.value.isNotEmpty &&
        tripType.value.isNotEmpty;
  }
  bool hasAnyChanges() {
    if (originalTrip.value == null) return false;

    final trip = originalTrip.value!;

    return (selectedTripDate.value != null && selectedTripDate.value != trip.tripDate) ||
        (selectedBilledTo.value.isNotEmpty && selectedBilledTo.value != trip.billedTo) ;
    // ... checks for all other fields
  }
  /// Update trip in Firestore

  Future<void> updateTrip() async {
    try {
      isUpdating.value = true;

      final tripId = await _getTripDocumentId();
      if (tripId == null) {
        _showErrorMessage('Error', 'Trip not found');
        return;
      }

      print('tripId: $tripId');

      final updatedData = {
        'trip_date': selectedTripDate.value,
        'billed_to': selectedBilledTo.value,
        'billed_vehicle': selectedBilledVehicle.value,
        'driver_name': selectedDriver.value,
        'sources': selectedSource.value,
        'destination': selectedDestination.value,
        'consignor': selectedConsignor.value,
        'consignee': selectedConsignee.value,  // Extract ID from DocumentReference
        'trip_type': tripType.value,
        'updated_at': FieldValue.serverTimestamp(),
      };

      print('Updating trip with data: $updatedData');

      await _fireStore.collection('trips').doc(tripId).update(updatedData);

      _showSuccessMessage('Success', 'Trip updated successfully');
      Get.to(() =>  TridentNavigationBar());

    } catch (e) {
      _handleError('Failed to update trip', e);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> approveTrip() async {
    try {
      isApproving.value = true;

      final tripId = await _getTripDocumentId();
      if (tripId == null) {
        _showErrorMessage('Error', 'Trip not found');
        return;
      }

      final userMobile = await _storage.read('user_mobile_no');

      final approvalData = {
        'in_review': false,
        'trip_status': 'Open'
      };

      await _fireStore.collection('trips').doc(tripId).update(approvalData);

      _showSuccessMessage('Success', 'Trip approved successfully');
      Get.to(() =>  TridentNavigationBar());

    } catch (e) {
      _handleError('Failed to approve trip', e);
    } finally {
      isApproving.value = false;
    }
  }

  Future<String?> _getTripDocumentId() async {
    try {
      if (originalTrip.value?.createdAt == null) return null;

      final snapshot = await _fireStore
          .collection('trips')
          .where('created_at', isEqualTo: Timestamp.fromDate(originalTrip.value!.createdAt!))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return snapshot.docs.first.id;
    } catch (e) {
      _handleError('Failed to get trip ID', e);
      return null;
    }
  }

  /// Stream trips for review (where in_review = true)
  Stream<List<TripModel>> getTripsForReview() {
    return _fireStore
        .collection('trips')
        .where('in_review', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TripModel.fromJson({
      ...doc.data(),
      'id': doc.id,
    }))
        .toList());
  }

  // ================== EXISTING FUNCTIONALITY ==================

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

  // ================== SEARCH AND FILTERING FUNCTIONALITY ==================

  // Text controllers for search
  final TextEditingController searchController = TextEditingController();

  // Observable variables for search and filters
  var searchQuery = ''.obs;
  var selectedDateFilter = 'all'.obs; // all, today, this_week, this_month
  var selectedStatusFilter = 'all'.obs;
  var selectedDriverFilter = 'all'.obs;
  var selectedSortBy = 'date_newest'.obs; // date_newest, date_oldest, destination_az, destination_za, driver_az, status

  // Filtered and sorted trips list
  var filteredTrips = <dynamic>[].obs;

  // Initialize search and filter functionality
  void initializeSearchAndFilter() {
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applyFiltersAndSort();
    });

    // Listen to filter changes
    ever(selectedDateFilter, (_) => _applyFiltersAndSort());
    ever(selectedStatusFilter, (_) => _applyFiltersAndSort());
    ever(selectedDriverFilter, (_) => _applyFiltersAndSort());
    ever(selectedSortBy, (_) => _applyFiltersAndSort());
  }

  // Apply search query filter
  List<dynamic> _applySearchFilter(List<dynamic> trips) {
    if (searchQuery.value.isEmpty) return trips;

    final query = searchQuery.value.toLowerCase();
    return trips.where((trip) {
      final destination = (trip.destination?.toString() ?? '').toLowerCase();
      final source = (trip.source?.toString() ?? '').toLowerCase();
      final driverName = (trip.driverName?.toString() ?? '').toLowerCase();
      final billedVehicle = (trip.billedVehicle?.toString() ?? '').toLowerCase();
      final consignor = (trip.consignor?.toString() ?? '').toLowerCase();

      return destination.contains(query) ||
          source.contains(query) ||
          driverName.contains(query) ||
          billedVehicle.contains(query) ||
          consignor.contains(query);
    }).toList();
  }

  // Apply date filter
  List<dynamic> _applyDateFilter(List<dynamic> trips) {
    if (selectedDateFilter.value == 'all') return trips;

    final now = DateTime.now();
    DateTime startDate;

    switch (selectedDateFilter.value) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'this_week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'this_month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      default:
        return trips;
    }

    return trips.where((trip) {
      if (trip.createdAt == null) return false;

      final tripDate = trip.createdAt is DateTime
          ? trip.createdAt as DateTime
          : DateTime.tryParse(trip.createdAt.toString());

      if (tripDate == null) return false;

      return tripDate.isAfter(startDate) || tripDate.isAtSameMomentAs(startDate);
    }).toList();
  }

  // Apply status filter
  List<dynamic> _applyStatusFilter(List<dynamic> trips) {
    if (selectedStatusFilter.value == 'all') return trips;

    return trips.where((trip) {
      final status = (trip.status?.toString().toLowerCase() ?? '');
      final filterStatus = selectedStatusFilter.value.toLowerCase();

      if (filterStatus == 'in_review') {
        return trip.in_review == true;
      }

      return status.contains(filterStatus.replaceAll('_', ' '));
    }).toList();
  }

  // Apply driver filter
  List<dynamic> _applyDriverFilter(List<dynamic> trips) {
    if (selectedDriverFilter.value == 'all') return trips;

    return trips.where((trip) {
      final driverName = (trip.driverName?.toString() ?? '');
      return driverName == selectedDriverFilter.value;
    }).toList();
  }

  // Apply sorting
  List<dynamic> _applySorting(List<dynamic> trips) {
    final sortedTrips = List<dynamic>.from(trips);

    switch (selectedSortBy.value) {
      case 'date_newest':
        sortedTrips.sort((a, b) {
          final dateA = a.createdAt is DateTime
              ? a.createdAt as DateTime
              : DateTime.tryParse(a.createdAt?.toString() ?? '') ?? DateTime.now();
          final dateB = b.createdAt is DateTime
              ? b.createdAt as DateTime
              : DateTime.tryParse(b.createdAt?.toString() ?? '') ?? DateTime.now();
          return dateB.compareTo(dateA);
        });
        break;
      case 'date_oldest':
        sortedTrips.sort((a, b) {
          final dateA = a.createdAt is DateTime
              ? a.createdAt as DateTime
              : DateTime.tryParse(a.createdAt?.toString() ?? '') ?? DateTime.now();
          final dateB = b.createdAt is DateTime
              ? b.createdAt as DateTime
              : DateTime.tryParse(b.createdAt?.toString() ?? '') ?? DateTime.now();
          return dateA.compareTo(dateB);
        });
        break;
      case 'destination_az':
        sortedTrips.sort((a, b) {
          final destA = (a.destination?.toString() ?? '').toLowerCase();
          final destB = (b.destination?.toString() ?? '').toLowerCase();
          return destA.compareTo(destB);
        });
        break;
      case 'destination_za':
        sortedTrips.sort((a, b) {
          final destA = (a.destination?.toString() ?? '').toLowerCase();
          final destB = (b.destination?.toString() ?? '').toLowerCase();
          return destB.compareTo(destA);
        });
        break;
      case 'driver_az':
        sortedTrips.sort((a, b) {
          final driverA = (a.driverName?.toString() ?? '').toLowerCase();
          final driverB = (b.driverName?.toString() ?? '').toLowerCase();
          return driverA.compareTo(driverB);
        });
        break;
      case 'status':
        sortedTrips.sort((a, b) {
          final statusA = (a.status?.toString() ?? '').toLowerCase();
          final statusB = (b.status?.toString() ?? '').toLowerCase();
          return statusA.compareTo(statusB);
        });
        break;
    }

    return sortedTrips;
  }

  // Apply all filters and sorting
  void _applyFiltersAndSort() {
    // This method will be called by the UI to get filtered trips for specific status
  }

  // Get filtered trips for specific tab status
  List<dynamic> getFilteredTripsForStatus(List<dynamic> allTrips, String tabStatus) {
    // First filter by tab status
    List<dynamic> statusFilteredTrips;

    if (tabStatus == 'all') {
      statusFilteredTrips = allTrips;
    } else if (tabStatus == 'in_review') {
      statusFilteredTrips = allTrips.where((trip) {
        final status = (trip.status?.toString().toLowerCase() ?? '');
        return status.contains('in_review');
      }).toList();    } else if (tabStatus == 'completed') {
      statusFilteredTrips = allTrips.where((trip) {
        final status = (trip.status?.toString().toLowerCase() ?? '');
        return status.contains('completed') || status.contains('vehicle return');
      }).toList();
    } else {
      // For specific stages like 'Vehicle Dock', 'Vehicle Loading', etc.
      statusFilteredTrips = allTrips.where((trip) {
        final status = (trip.status?.toString().toLowerCase() ?? '');
        final tabStatusLower = tabStatus.toLowerCase().replaceAll(' ', '');
        return status.replaceAll(' ', '').contains(tabStatusLower);
      }).toList();
    }

    // Apply search filter
    var filteredList = _applySearchFilter(statusFilteredTrips);

    // Apply date filter
    filteredList = _applyDateFilter(filteredList);

    // Apply additional status filter (from filter options)
    if (selectedStatusFilter.value != 'all') {
      filteredList = _applyStatusFilter(filteredList);
    }

    // Apply driver filter
    filteredList = _applyDriverFilter(filteredList);

    // Apply sorting
    filteredList = _applySorting(filteredList);

    return filteredList;
  }

  // Clear all filters
  void clearAllFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedDateFilter.value = 'all';
    selectedStatusFilter.value = 'all';
    selectedDriverFilter.value = 'all';
    selectedSortBy.value = 'date_newest';
  }

  // Update date filter
  void updateDateFilter(String filter) {
    selectedDateFilter.value = filter;
  }

  // Update status filter
  void updateStatusFilter(String filter) {
    selectedStatusFilter.value = filter;
  }

  // Update driver filter
  void updateDriverFilter(String filter) {
    selectedDriverFilter.value = filter;
  }

  // Update sort option
  void updateSortOption(String sortBy) {
    selectedSortBy.value = sortBy;
  }

  // Get unique drivers for filter dropdown
  List<String> getUniqueDriversFromTrips(List<dynamic> trips) {
    final drivers = trips
        .map((trip) => trip.driverName?.toString() ?? '')
        .where((driver) => driver.isNotEmpty)
        .toSet()
        .toList();
    drivers.sort();
    return drivers;
  }

  // Get filter options for different categories
  List<Map<String, String>> get dateFilterOptions => [
    {'value': 'all', 'label': 'All Time'},
    {'value': 'today', 'label': 'Today'},
    {'value': 'this_week', 'label': 'This Week'},
    {'value': 'this_month', 'label': 'This Month'},
  ];

  List<Map<String, String>> get statusFilterOptions => [
    {'value': 'all', 'label': 'All Status'},
    {'value': 'open', 'label': 'Open'},
    {'value': 'in_review', 'label': 'In Review'},
    {'value': 'completed', 'label': 'Completed'},
    {'value': 'vehicle_dock', 'label': 'Vehicle Dock'},
    {'value': 'vehicle_loading', 'label': 'Vehicle Loading'},
    {'value': 'dispatch', 'label': 'Dispatch'},
    {'value': 'vehicle_return', 'label': 'Vehicle Return'},
  ];

  List<Map<String, String>> get sortOptions => [
    {'value': 'date_newest', 'label': 'Date Created (Newest)'},
    {'value': 'date_oldest', 'label': 'Date Created (Oldest)'},
    {'value': 'destination_az', 'label': 'Destination (A-Z)'},
    {'value': 'destination_za', 'label': 'Destination (Z-A)'},
    {'value': 'driver_az', 'label': 'Driver Name (A-Z)'},
    {'value': 'status', 'label': 'Status'},
  ];

  @override
  void onReady() {
    super.onReady();
    initializeSearchAndFilter();
  }


}