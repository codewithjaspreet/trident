import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/vehicle_model.dart';
import '../views/vehicle_listing.dart';

class VehicleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable state variables
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isUpdating = false.obs;
  var isDeleting = false.obs;
  var vehicles = <VehicleModel>[].obs;
  var searchQuery = ''.obs;
  var selectedVehicle = Rxn<VehicleModel>();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final chassisNoController = TextEditingController();
  final companyMakeController = TextEditingController();
  final companyModelController = TextEditingController();
  final crateCapacityController = TextEditingController();
  final engineNoController = TextEditingController();
  final fitnessDateController = TextEditingController();
  final gvwController = TextEditingController();
  final insuranceDateController = TextEditingController();
  final noOfCylindersController = TextEditingController();
  final np5YearController = TextEditingController();
  final npAnnualController = TextEditingController();
  final ownerNameController = TextEditingController();
  final payloadController = TextEditingController();
  final refMakeModelController = TextEditingController();
  final registrationDateController = TextEditingController();
  final registrationNoController = TextEditingController();
  final roadTaxStatusController = TextEditingController();
  final tyreSizeController = TextEditingController();
  final unladenWtController = TextEditingController();
  final vehSlNoController = TextEditingController();
  final vehicleNoController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final wheelBaseController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  @override
  void onClose() {
    // Dispose all controllers
    chassisNoController.dispose();
    companyMakeController.dispose();
    companyModelController.dispose();
    crateCapacityController.dispose();
    engineNoController.dispose();
    fitnessDateController.dispose();
    gvwController.dispose();
    insuranceDateController.dispose();
    noOfCylindersController.dispose();
    np5YearController.dispose();
    npAnnualController.dispose();
    ownerNameController.dispose();
    payloadController.dispose();
    refMakeModelController.dispose();
    registrationDateController.dispose();
    registrationNoController.dispose();
    roadTaxStatusController.dispose();
    tyreSizeController.dispose();
    unladenWtController.dispose();
    vehSlNoController.dispose();
    vehicleNoController.dispose();
    vehicleTypeController.dispose();
    wheelBaseController.dispose();
    super.onClose();
  }

  // Fetch all vehicles from Firestore
  Future<void> fetchVehicles() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('vehicles')
          .orderBy('registrationNo', descending: false)
          .get();

      vehicles.value = snapshot.docs
          .map((doc) => VehicleModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _showError('Failed to load vehicles', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new vehicle
  Future<void> createVehicle() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isCreating.value = true;

      final vehicle = VehicleModel(
        chassisNo: chassisNoController.text.trim(),
        companyMake: companyMakeController.text.trim(),
        companyModel: companyModelController.text.trim(),
        crateCapacity: crateCapacityController.text.trim(),
        engineNo: engineNoController.text.trim(),
        fitnessDate: fitnessDateController.text.trim(),
        gvw: gvwController.text.trim(),
        insuranceDate: insuranceDateController.text.trim(),
        noOfCylinders: noOfCylindersController.text.trim(),
        np5Year: np5YearController.text.trim(),
        npAnnual: npAnnualController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        payload: payloadController.text.trim(),
        refMakeModel: refMakeModelController.text.trim(),
        registrationDate: registrationDateController.text.trim(),
        registrationNo: registrationNoController.text.trim(),
        roadTaxStatus: roadTaxStatusController.text.trim(),
        tyreSize: tyreSizeController.text.trim(),
        unladenWt: unladenWtController.text.trim(),
        vehSlNo: vehSlNoController.text.trim(),
        vehicleNo: vehicleNoController.text.trim(),
        vehicleType: vehicleTypeController.text.trim(),
        wheelBase: wheelBaseController.text.trim(),
      );

      await _firestore.collection('vehicles').add(vehicle.toMap());

      _showSuccess('Vehicle Created', 'Vehicle added successfully!');
      _clearForm();
      await fetchVehicles();
      Get.off(() => const VehicleListingScreen());
    } catch (e) {
      _showError('Failed to create vehicle', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  // Update an existing vehicle
  Future<void> updateVehicle(String vehicleId) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isUpdating.value = true;

      final updatedData = {
        'chassisNo': chassisNoController.text.trim(),
        'companyMake': companyMakeController.text.trim(),
        'companyModel': companyModelController.text.trim(),
        'crateCapacity': crateCapacityController.text.trim(),
        'engineNo': engineNoController.text.trim(),
        'fitnessDate': fitnessDateController.text.trim(),
        'gvw': gvwController.text.trim(),
        'insuranceDate': insuranceDateController.text.trim(),
        'noOfCylinders': noOfCylindersController.text.trim(),
        'np5Year': np5YearController.text.trim(),
        'npAnnual': npAnnualController.text.trim(),
        'ownerName': ownerNameController.text.trim(),
        'payload': payloadController.text.trim(),
        'refMakeModel': refMakeModelController.text.trim(),
        'registrationDate': registrationDateController.text.trim(),
        'registrationNo': registrationNoController.text.trim(),
        'roadTaxStatus': roadTaxStatusController.text.trim(),
        'tyreSize': tyreSizeController.text.trim(),
        'unladenWt': unladenWtController.text.trim(),
        'vehSlNo': vehSlNoController.text.trim(),
        'vehicleNo': vehicleNoController.text.trim(),
        'vehicleType': vehicleTypeController.text.trim(),
        'wheelBase': wheelBaseController.text.trim(),
      };

      await _firestore.collection('vehicles').doc(vehicleId).update(updatedData);

      _showSuccess('Vehicle Updated', 'Vehicle updated successfully!');
      _clearForm();
      await fetchVehicles();
      Get.off(() => const VehicleListingScreen());
    } catch (e) {
      _showError('Failed to update vehicle', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      isDeleting.value = true;
      await _firestore.collection('vehicles').doc(vehicleId).delete();
      _showSuccess('Vehicle Deleted', 'Vehicle deleted successfully!');
      await fetchVehicles();
    } catch (e) {
      _showError('Failed to delete vehicle', e.toString());
    } finally {
      isDeleting.value = false;
    }
  }

  // Initialize form with vehicle data for editing
  void initializeEditForm(VehicleModel vehicle) {
    chassisNoController.text = vehicle.chassisNo;
    companyMakeController.text = vehicle.companyMake;
    companyModelController.text = vehicle.companyModel;
    crateCapacityController.text = vehicle.crateCapacity;
    engineNoController.text = vehicle.engineNo;
    fitnessDateController.text = vehicle.fitnessDate;
    gvwController.text = vehicle.gvw;
    insuranceDateController.text = vehicle.insuranceDate;
    noOfCylindersController.text = vehicle.noOfCylinders;
    np5YearController.text = vehicle.np5Year;
    npAnnualController.text = vehicle.npAnnual;
    ownerNameController.text = vehicle.ownerName;
    payloadController.text = vehicle.payload;
    refMakeModelController.text = vehicle.refMakeModel;
    registrationDateController.text = vehicle.registrationDate;
    registrationNoController.text = vehicle.registrationNo;
    roadTaxStatusController.text = vehicle.roadTaxStatus;
    tyreSizeController.text = vehicle.tyreSize;
    unladenWtController.text = vehicle.unladenWt;
    vehSlNoController.text = vehicle.vehSlNo;
    vehicleNoController.text = vehicle.vehicleNo;
    vehicleTypeController.text = vehicle.vehicleType;
    wheelBaseController.text = vehicle.wheelBase;
    selectedVehicle.value = vehicle;
  }

  // Clear form fields
  void _clearForm() {
    chassisNoController.clear();
    companyMakeController.clear();
    companyModelController.clear();
    crateCapacityController.clear();
    engineNoController.clear();
    fitnessDateController.clear();
    gvwController.clear();
    insuranceDateController.clear();
    noOfCylindersController.clear();
    np5YearController.clear();
    npAnnualController.clear();
    ownerNameController.clear();
    payloadController.clear();
    refMakeModelController.clear();
    registrationDateController.clear();
    registrationNoController.clear();
    roadTaxStatusController.clear();
    tyreSizeController.clear();
    unladenWtController.clear();
    vehSlNoController.clear();
    vehicleNoController.clear();
    vehicleTypeController.clear();
    wheelBaseController.clear();
    selectedVehicle.value = null;
  }

  // Get filtered vehicles based on search query
  List<VehicleModel> get filteredVehicles {
    if (searchQuery.value.isEmpty) {
      return vehicles;
    }
    final query = searchQuery.value.toLowerCase();
    return vehicles.where((vehicle) {
      return vehicle.registrationNo.toLowerCase().contains(query) ||
          vehicle.vehicleNo.toLowerCase().contains(query) ||
          vehicle.companyMake.toLowerCase().contains(query) ||
          vehicle.companyModel.toLowerCase().contains(query) ||
          vehicle.chassisNo.toLowerCase().contains(query) ||
          vehicle.ownerName.toLowerCase().contains(query);
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

