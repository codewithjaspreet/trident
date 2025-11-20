import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String? id;
  final String aadharNo;
  final String bankAccountNo;
  final String dlExpiryDate;
  final String dlIssueDate;
  final String dlNo;
  final String dob;
  final String driverName;
  final String drvNspNo;
  final String emergencyContactNo;
  final String emergencyContactRelation;
  final String guarantorName;
  final String ifscCode;
  final String insuranceStatus;
  final String maritalStatus;
  final String mobileNo;
  final String nspExpiryDate;
  final String panNo;
  final String relativeName;
  final String sonOf;

  DriverModel({
    this.id,
    required this.aadharNo,
    required this.bankAccountNo,
    required this.dlExpiryDate,
    required this.dlIssueDate,
    required this.dlNo,
    required this.dob,
    required this.driverName,
    required this.drvNspNo,
    required this.emergencyContactNo,
    required this.emergencyContactRelation,
    required this.guarantorName,
    required this.ifscCode,
    required this.insuranceStatus,
    required this.maritalStatus,
    required this.mobileNo,
    required this.nspExpiryDate,
    required this.panNo,
    required this.relativeName,
    required this.sonOf,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'aadharNo': aadharNo,
      'bankAccountNo': bankAccountNo,
      'dlExpiryDate': dlExpiryDate,
      'dlIssueDate': dlIssueDate,
      'dlNo': dlNo,
      'dob': dob,
      'driverName': driverName,
      'drvNspNo': drvNspNo,
      'emergencyContactNo': emergencyContactNo,
      'emergencyContactRelation': emergencyContactRelation,
      'guarantorName': guarantorName,
      'ifscCode': ifscCode,
      'insuranceStatus': insuranceStatus,
      'maritalStatus': maritalStatus,
      'mobileNo': mobileNo,
      'nspExpiryDate': nspExpiryDate,
      'panNo': panNo,
      'relativeName': relativeName,
      'sonOf': sonOf,
    };
  }

  // Create from Firestore document
  factory DriverModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return DriverModel(
      id: docId,
      aadharNo: data['aadharNo'] as String? ?? '',
      bankAccountNo: data['bankAccountNo'] as String? ?? '',
      dlExpiryDate: data['dlExpiryDate'] as String? ?? '',
      dlIssueDate: data['dlIssueDate'] as String? ?? '',
      dlNo: data['dlNo'] as String? ?? '',
      dob: data['dob'] as String? ?? '',
      driverName: data['driverName'] as String? ?? '',
      drvNspNo: data['drvNspNo'] as String? ?? '',
      emergencyContactNo: data['emergencyContactNo'] as String? ?? '',
      emergencyContactRelation: data['emergencyContactRelation'] as String? ?? '',
      guarantorName: data['guarantorName'] as String? ?? '',
      ifscCode: data['ifscCode'] as String? ?? '',
      insuranceStatus: data['insuranceStatus'] as String? ?? '',
      maritalStatus: data['maritalStatus'] as String? ?? '',
      mobileNo: data['mobileNo'] as String? ?? '',
      nspExpiryDate: data['nspExpiryDate'] as String? ?? '',
      panNo: data['panNo'] as String? ?? '',
      relativeName: data['relativeName'] as String? ?? '',
      sonOf: data['sonOf'] as String? ?? '',
    );
  }

  // Create a copy with updated fields
  DriverModel copyWith({
    String? id,
    String? aadharNo,
    String? bankAccountNo,
    String? dlExpiryDate,
    String? dlIssueDate,
    String? dlNo,
    String? dob,
    String? driverName,
    String? drvNspNo,
    String? emergencyContactNo,
    String? emergencyContactRelation,
    String? guarantorName,
    String? ifscCode,
    String? insuranceStatus,
    String? maritalStatus,
    String? mobileNo,
    String? nspExpiryDate,
    String? panNo,
    String? relativeName,
    String? sonOf,
  }) {
    return DriverModel(
      id: id ?? this.id,
      aadharNo: aadharNo ?? this.aadharNo,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      dlExpiryDate: dlExpiryDate ?? this.dlExpiryDate,
      dlIssueDate: dlIssueDate ?? this.dlIssueDate,
      dlNo: dlNo ?? this.dlNo,
      dob: dob ?? this.dob,
      driverName: driverName ?? this.driverName,
      drvNspNo: drvNspNo ?? this.drvNspNo,
      emergencyContactNo: emergencyContactNo ?? this.emergencyContactNo,
      emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
      guarantorName: guarantorName ?? this.guarantorName,
      ifscCode: ifscCode ?? this.ifscCode,
      insuranceStatus: insuranceStatus ?? this.insuranceStatus,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      mobileNo: mobileNo ?? this.mobileNo,
      nspExpiryDate: nspExpiryDate ?? this.nspExpiryDate,
      panNo: panNo ?? this.panNo,
      relativeName: relativeName ?? this.relativeName,
      sonOf: sonOf ?? this.sonOf,
    );
  }
}

