import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  final String? id;
  final String chassisNo;
  final String companyMake;
  final String companyModel;
  final String crateCapacity;
  final String engineNo;
  final String fitnessDate;
  final String gvw;
  final String insuranceDate;
  final String noOfCylinders;
  final String np5Year;
  final String npAnnual;
  final String ownerName;
  final String payload;
  final String refMakeModel;
  final String registrationDate;
  final String registrationNo;
  final String roadTaxStatus;
  final String tyreSize;
  final String unladenWt;
  final String vehSlNo;
  final String vehicleNo;
  final String vehicleType;
  final String wheelBase;

  VehicleModel({
    this.id,
    required this.chassisNo,
    required this.companyMake,
    required this.companyModel,
    required this.crateCapacity,
    required this.engineNo,
    required this.fitnessDate,
    required this.gvw,
    required this.insuranceDate,
    required this.noOfCylinders,
    required this.np5Year,
    required this.npAnnual,
    required this.ownerName,
    required this.payload,
    required this.refMakeModel,
    required this.registrationDate,
    required this.registrationNo,
    required this.roadTaxStatus,
    required this.tyreSize,
    required this.unladenWt,
    required this.vehSlNo,
    required this.vehicleNo,
    required this.vehicleType,
    required this.wheelBase,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'chassisNo': chassisNo,
      'companyMake': companyMake,
      'companyModel': companyModel,
      'crateCapacity': crateCapacity,
      'engineNo': engineNo,
      'fitnessDate': fitnessDate,
      'gvw': gvw,
      'insuranceDate': insuranceDate,
      'noOfCylinders': noOfCylinders,
      'np5Year': np5Year,
      'npAnnual': npAnnual,
      'ownerName': ownerName,
      'payload': payload,
      'refMakeModel': refMakeModel,
      'registrationDate': registrationDate,
      'registrationNo': registrationNo,
      'roadTaxStatus': roadTaxStatus,
      'tyreSize': tyreSize,
      'unladenWt': unladenWt,
      'vehSlNo': vehSlNo,
      'vehicleNo': vehicleNo,
      'vehicleType': vehicleType,
      'wheelBase': wheelBase,
    };
  }

  // Create from Firestore document
  factory VehicleModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return VehicleModel(
      id: docId,
      chassisNo: data['chassisNo'] as String? ?? '',
      companyMake: data['companyMake'] as String? ?? '',
      companyModel: data['companyModel'] as String? ?? '',
      crateCapacity: data['crateCapacity'] as String? ?? '',
      engineNo: data['engineNo'] as String? ?? '',
      fitnessDate: data['fitnessDate'] as String? ?? '',
      gvw: data['gvw'] as String? ?? '',
      insuranceDate: data['insuranceDate'] as String? ?? '',
      noOfCylinders: data['noOfCylinders'] as String? ?? '',
      np5Year: data['np5Year'] as String? ?? '',
      npAnnual: data['npAnnual'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? '',
      payload: data['payload'] as String? ?? '',
      refMakeModel: data['refMakeModel'] as String? ?? '',
      registrationDate: data['registrationDate'] as String? ?? '',
      registrationNo: data['registrationNo'] as String? ?? '',
      roadTaxStatus: data['roadTaxStatus'] as String? ?? '',
      tyreSize: data['tyreSize'] as String? ?? '',
      unladenWt: data['unladenWt'] as String? ?? '',
      vehSlNo: data['vehSlNo'] as String? ?? '',
      vehicleNo: data['vehicleNo'] as String? ?? '',
      vehicleType: data['vehicleType'] as String? ?? '',
      wheelBase: data['wheelBase'] as String? ?? '',
    );
  }

  // Create a copy with updated fields
  VehicleModel copyWith({
    String? id,
    String? chassisNo,
    String? companyMake,
    String? companyModel,
    String? crateCapacity,
    String? engineNo,
    String? fitnessDate,
    String? gvw,
    String? insuranceDate,
    String? noOfCylinders,
    String? np5Year,
    String? npAnnual,
    String? ownerName,
    String? payload,
    String? refMakeModel,
    String? registrationDate,
    String? registrationNo,
    String? roadTaxStatus,
    String? tyreSize,
    String? unladenWt,
    String? vehSlNo,
    String? vehicleNo,
    String? vehicleType,
    String? wheelBase,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      chassisNo: chassisNo ?? this.chassisNo,
      companyMake: companyMake ?? this.companyMake,
      companyModel: companyModel ?? this.companyModel,
      crateCapacity: crateCapacity ?? this.crateCapacity,
      engineNo: engineNo ?? this.engineNo,
      fitnessDate: fitnessDate ?? this.fitnessDate,
      gvw: gvw ?? this.gvw,
      insuranceDate: insuranceDate ?? this.insuranceDate,
      noOfCylinders: noOfCylinders ?? this.noOfCylinders,
      np5Year: np5Year ?? this.np5Year,
      npAnnual: npAnnual ?? this.npAnnual,
      ownerName: ownerName ?? this.ownerName,
      payload: payload ?? this.payload,
      refMakeModel: refMakeModel ?? this.refMakeModel,
      registrationDate: registrationDate ?? this.registrationDate,
      registrationNo: registrationNo ?? this.registrationNo,
      roadTaxStatus: roadTaxStatus ?? this.roadTaxStatus,
      tyreSize: tyreSize ?? this.tyreSize,
      unladenWt: unladenWt ?? this.unladenWt,
      vehSlNo: vehSlNo ?? this.vehSlNo,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      vehicleType: vehicleType ?? this.vehicleType,
      wheelBase: wheelBase ?? this.wheelBase,
    );
  }
}

