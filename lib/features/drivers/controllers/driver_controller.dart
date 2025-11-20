import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/driver_model.dart';
import '../views/driver_listing.dart';

class DriverController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable state variables
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isUpdating = false.obs;
  var isDeleting = false.obs;
  var drivers = <DriverModel>[].obs;
  var searchQuery = ''.obs;
  var selectedDriver = Rxn<DriverModel>();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final aadharNoController = TextEditingController();
  final bankAccountNoController = TextEditingController();
  final dlExpiryDateController = TextEditingController();
  final dlIssueDateController = TextEditingController();
  final dlNoController = TextEditingController();
  final dobController = TextEditingController();
  final driverNameController = TextEditingController();
  final drvNspNoController = TextEditingController();
  final emergencyContactNoController = TextEditingController();
  final emergencyContactRelationController = TextEditingController();
  final guarantorNameController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final insuranceStatusController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final mobileNoController = TextEditingController();
  final nspExpiryDateController = TextEditingController();
  final panNoController = TextEditingController();
  final relativeNameController = TextEditingController();
  final sonOfController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
  }

  @override
  void onClose() {
    // Dispose all controllers
    aadharNoController.dispose();
    bankAccountNoController.dispose();
    dlExpiryDateController.dispose();
    dlIssueDateController.dispose();
    dlNoController.dispose();
    dobController.dispose();
    driverNameController.dispose();
    drvNspNoController.dispose();
    emergencyContactNoController.dispose();
    emergencyContactRelationController.dispose();
    guarantorNameController.dispose();
    ifscCodeController.dispose();
    insuranceStatusController.dispose();
    maritalStatusController.dispose();
    mobileNoController.dispose();
    nspExpiryDateController.dispose();
    panNoController.dispose();
    relativeNameController.dispose();
    sonOfController.dispose();
    super.onClose();
  }

  // Fetch all drivers from Firestore
  Future<void> fetchDrivers() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('drivers')
          .orderBy('driverName', descending: false)
          .get();

      drivers.value = snapshot.docs
          .map((doc) => DriverModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _showError('Failed to load drivers', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new driver
  Future<void> createDriver() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isCreating.value = true;

      final driver = DriverModel(
        aadharNo: aadharNoController.text.trim(),
        bankAccountNo: bankAccountNoController.text.trim(),
        dlExpiryDate: dlExpiryDateController.text.trim(),
        dlIssueDate: dlIssueDateController.text.trim(),
        dlNo: dlNoController.text.trim(),
        dob: dobController.text.trim(),
        driverName: driverNameController.text.trim(),
        drvNspNo: drvNspNoController.text.trim(),
        emergencyContactNo: emergencyContactNoController.text.trim(),
        emergencyContactRelation: emergencyContactRelationController.text.trim(),
        guarantorName: guarantorNameController.text.trim(),
        ifscCode: ifscCodeController.text.trim(),
        insuranceStatus: insuranceStatusController.text.trim(),
        maritalStatus: maritalStatusController.text.trim(),
        mobileNo: mobileNoController.text.trim(),
        nspExpiryDate: nspExpiryDateController.text.trim(),
        panNo: panNoController.text.trim(),
        relativeName: relativeNameController.text.trim(),
        sonOf: sonOfController.text.trim(),
      );

      await _firestore.collection('drivers').add(driver.toMap());

      _showSuccess('Driver Created', 'Driver added successfully!');
      _clearForm();
      await fetchDrivers();
      Get.off(() => const DriverListingScreen());
    } catch (e) {
      _showError('Failed to create driver', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  // Update an existing driver
  Future<void> updateDriver(String driverId) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isUpdating.value = true;

      final updatedData = {
        'aadharNo': aadharNoController.text.trim(),
        'bankAccountNo': bankAccountNoController.text.trim(),
        'dlExpiryDate': dlExpiryDateController.text.trim(),
        'dlIssueDate': dlIssueDateController.text.trim(),
        'dlNo': dlNoController.text.trim(),
        'dob': dobController.text.trim(),
        'driverName': driverNameController.text.trim(),
        'drvNspNo': drvNspNoController.text.trim(),
        'emergencyContactNo': emergencyContactNoController.text.trim(),
        'emergencyContactRelation': emergencyContactRelationController.text.trim(),
        'guarantorName': guarantorNameController.text.trim(),
        'ifscCode': ifscCodeController.text.trim(),
        'insuranceStatus': insuranceStatusController.text.trim(),
        'maritalStatus': maritalStatusController.text.trim(),
        'mobileNo': mobileNoController.text.trim(),
        'nspExpiryDate': nspExpiryDateController.text.trim(),
        'panNo': panNoController.text.trim(),
        'relativeName': relativeNameController.text.trim(),
        'sonOf': sonOfController.text.trim(),
      };

      await _firestore.collection('drivers').doc(driverId).update(updatedData);

      _showSuccess('Driver Updated', 'Driver updated successfully!');
      _clearForm();
      await fetchDrivers();
      Get.off(() => const DriverListingScreen());
    } catch (e) {
      _showError('Failed to update driver', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete a driver
  Future<void> deleteDriver(String driverId) async {
    try {
      isDeleting.value = true;
      await _firestore.collection('drivers').doc(driverId).delete();
      _showSuccess('Driver Deleted', 'Driver deleted successfully!');
      await fetchDrivers();
    } catch (e) {
      _showError('Failed to delete driver', e.toString());
    } finally {
      isDeleting.value = false;
    }
  }

  // Initialize form with driver data for editing
  void initializeEditForm(DriverModel driver) {
    aadharNoController.text = driver.aadharNo;
    bankAccountNoController.text = driver.bankAccountNo;
    dlExpiryDateController.text = driver.dlExpiryDate;
    dlIssueDateController.text = driver.dlIssueDate;
    dlNoController.text = driver.dlNo;
    dobController.text = driver.dob;
    driverNameController.text = driver.driverName;
    drvNspNoController.text = driver.drvNspNo;
    emergencyContactNoController.text = driver.emergencyContactNo;
    emergencyContactRelationController.text = driver.emergencyContactRelation;
    guarantorNameController.text = driver.guarantorName;
    ifscCodeController.text = driver.ifscCode;
    insuranceStatusController.text = driver.insuranceStatus;
    maritalStatusController.text = driver.maritalStatus;
    mobileNoController.text = driver.mobileNo;
    nspExpiryDateController.text = driver.nspExpiryDate;
    panNoController.text = driver.panNo;
    relativeNameController.text = driver.relativeName;
    sonOfController.text = driver.sonOf;
    selectedDriver.value = driver;
  }

  // Clear form fields
  void _clearForm() {
    aadharNoController.clear();
    bankAccountNoController.clear();
    dlExpiryDateController.clear();
    dlIssueDateController.clear();
    dlNoController.clear();
    dobController.clear();
    driverNameController.clear();
    drvNspNoController.clear();
    emergencyContactNoController.clear();
    emergencyContactRelationController.clear();
    guarantorNameController.clear();
    ifscCodeController.clear();
    insuranceStatusController.clear();
    maritalStatusController.clear();
    mobileNoController.clear();
    nspExpiryDateController.clear();
    panNoController.clear();
    relativeNameController.clear();
    sonOfController.clear();
    selectedDriver.value = null;
  }

  // Get filtered drivers based on search query
  List<DriverModel> get filteredDrivers {
    if (searchQuery.value.isEmpty) {
      return drivers;
    }
    final query = searchQuery.value.toLowerCase();
    return drivers.where((driver) {
      return driver.driverName.toLowerCase().contains(query) ||
          driver.mobileNo.contains(query) ||
          driver.dlNo.toLowerCase().contains(query) ||
          driver.aadharNo.contains(query);
    }).toList();
  }

  // Show success message
  void _showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Show error message
  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}

