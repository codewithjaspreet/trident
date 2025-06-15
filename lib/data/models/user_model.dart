class UserModel {
  String userMobileNumber;
  String userRole;

  UserModel({required this.userRole, required this.userMobileNumber});

  Map<String, dynamic> toMap() {
    return {
      'user_mobile_no': userMobileNumber,
      'user_role': userRole,
    };
  }
}
