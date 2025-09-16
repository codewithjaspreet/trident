import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/routes/routes.dart';
import '../../../utils/device/device_utility.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString verificationId = ''.obs;
  final Rx<ConfirmationResult?> desktopConfirmationResult =
      Rx<ConfirmationResult?>(null);

  late RecaptchaVerifier _recaptchaVerifier;

  @override
  void onInit() {
    super.onInit();
  }



  void handleAppLaunch() {
    final user = _auth.currentUser;
    final storedRole = _storage.read('user_role');

    Future.microtask(() {
      if (user != null && storedRole != null) {
        debugPrint('[Auth] Redirecting to dashboard');

        if(storedRole == 'driver') {
          Get.toNamed(TRoutes.navigationBar);
        }
        Get.toNamed(TRoutes.navigationBar);
      } else {
        debugPrint('[Auth] Redirecting to login');
        Get.toNamed(TRoutes.loginScreen);
      }
    });
  }

  void _setupRecaptcha() {
    _recaptchaVerifier = RecaptchaVerifier(
      auth: FirebaseAuthPlatform.instance,
      onSuccess: () => debugPrint('reCAPTCHA completed!'),
      onError: (e) => debugPrint('reCAPTCHA error: ${e.message}'),
      onExpired: () => debugPrint('reCAPTCHA expired'),
    );
  }

  String _formatPhoneNumber(String raw) {
    raw = raw.replaceAll(' ', '').trim();
    return raw.startsWith('+') ? raw : '+91$raw';
  }

  Future<void> sendOtp(BuildContext context) async {
    final phoneNumber = _formatPhoneNumber(phoneController.text);

    // ✅ Show loading popup
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    try {
      if (TDeviceUtils.isDesktopScreen(context)) {
        _setupRecaptcha();
        final confirmation = await _auth.signInWithPhoneNumber(
          phoneNumber,
          _recaptchaVerifier,
        );
        desktopConfirmationResult.value = confirmation;
        debugPrint('[Navigation] Redirecting to OTP Screen (desktop)');
        Get.back(); // ✅ Close dialog before navigation
        Get.toNamed(TRoutes.otpScreen);
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
            await _handleUserPostVerification();
          },
          verificationFailed: (e) {
            Get.back(); // ✅ Ensure dialog is closed on error
            Get.snackbar('Error', e.message ?? 'Verification failed');
          },
          codeSent: (verId, _) {
            verificationId.value = verId;
            debugPrint('[Navigation] Redirecting to OTP Screen (mobile)');
            Get.back(); // ✅ Close dialog before navigating
            Get.toNamed(TRoutes.otpScreen);
          },
          codeAutoRetrievalTimeout: (verId) {
            verificationId.value = verId;
          },
        );
      }
    } catch (e) {
      Get.back(); // ✅ Always close dialog in error
      debugPrint('[Error] Failed to send OTP: $e');
      Get.snackbar(
        'OTP Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final smsCode = otpController.text.trim();
    if (smsCode.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential;

      if (desktopConfirmationResult.value != null) {
        userCredential =
            await desktopConfirmationResult.value!.confirm(smsCode);
      } else {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: smsCode,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      if (userCredential.user != null) {
        await _handleUserPostVerification();
      } else {
        Get.snackbar('Error', 'Verification failed. Please try again.');
        debugPrint('[Error] userCredential.user is null');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP or verification failed');
      debugPrint('[Error] OTP verification failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleUserPostVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('[Error] No user found after verification');
      return;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      final role = userDoc['role'];
      await _storage.write('user_role', role);
      await _storage.write('user_mobile_no', user.phoneNumber);
    } else {
      // First time user - default to driver
      await _firestore.collection('users').doc(user.uid).set({
        'mobile': user.phoneNumber,
        'role': 'driver',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _storage.write('user_role', 'driver');
      await _storage.write('user_mobile_no', user.phoneNumber);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '[Navigation] Redirecting to Dashboard from _handleUserPostVerification');
      Get.offAllNamed(TRoutes.navigationBar);
    });
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _storage.erase();
      phoneController.clear();
      otpController.clear();

      debugPrint('[Navigation] Redirecting to Login Screen from logout');
      Get.offAllNamed(TRoutes.loginScreen); // No need for postFrameCallback
    } catch (e) {
      Get.snackbar('Logout Failed', '$e.');
      debugPrint('[Error] Logout Failed: $e');
    }
  }
}
