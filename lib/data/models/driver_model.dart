class DriverModel {
  final String driverName;
  final String sonOf;
  final String mobileNo;
  final String dlNo;
  final String dlIssueDate;
  final String dlExpiryDate;
  final String relativeName;
  final String emergencyContactRelation;
  final String emergencyContactNo;
  final String dob;
  final String aadharNo;
  final String panNo;
  final String bankAccountNo;
  final String ifscCode;
  final String maritalStatus;
  final String guarantorName;
  final String drvNspNo;
  final String nspExpiryDate;
  final String insuranceStatus;

  DriverModel({
    required this.driverName,
    required this.sonOf,
    required this.mobileNo,
    required this.dlNo,
    required this.dlIssueDate,
    required this.dlExpiryDate,
    required this.relativeName,
    required this.emergencyContactRelation,
    required this.emergencyContactNo,
    required this.dob,
    required this.aadharNo,
    required this.panNo,
    required this.bankAccountNo,
    required this.ifscCode,
    required this.maritalStatus,
    required this.guarantorName,
    required this.drvNspNo,
    required this.nspExpiryDate,
    required this.insuranceStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'sonOf': sonOf,
      'mobileNo': mobileNo,
      'dlNo': dlNo,
      'dlIssueDate': dlIssueDate,
      'dlExpiryDate': dlExpiryDate,
      'relativeName': relativeName,
      'emergencyContactRelation': emergencyContactRelation,
      'emergencyContactNo': emergencyContactNo,
      'dob': dob,
      'aadharNo': aadharNo,
      'panNo': panNo,
      'bankAccountNo': bankAccountNo,
      'ifscCode': ifscCode,
      'maritalStatus': maritalStatus,
      'guarantorName': guarantorName,
      'drvNspNo': drvNspNo,
      'nspExpiryDate': nspExpiryDate,
      'insuranceStatus': insuranceStatus,
    };
  }
}