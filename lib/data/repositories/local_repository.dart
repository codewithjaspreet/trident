import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const String _keyUserMobileNo = 'userMobileNo';

  /// Save user's mobile number to local storage
  Future<void> setUserMobileNo(String mobileNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserMobileNo, mobileNo);
  }

  /// Retrieve user's mobile number from local storage
  Future<String?> getUserMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserMobileNo);
  }

  /// Clear saved user mobile number
  Future<void> clearUserMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserMobileNo);
  }
}
