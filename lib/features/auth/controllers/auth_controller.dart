import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/device/device_utility.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString verificationId = ''.obs;
  final Rx<ConfirmationResult?> desktopConfirmationResult = Rx<ConfirmationResult?>(null);

  late RecaptchaVerifier _recaptchaVerifier;

  void _setupRecaptcha() {
    _recaptchaVerifier = RecaptchaVerifier(
      auth: FirebaseAuthPlatform.instance,
      onSuccess: () => print('reCAPTCHA completed!'),
      onError: (e) => print('reCAPTCHA error: ${e.message}'),
      onExpired: () => print('reCAPTCHA expired'),
    );
  }

  String _formatPhoneNumber(String raw) {
    raw = raw.replaceAll(' ', '').trim();
    return raw.startsWith('+') ? raw : '+91$raw';
  }

  Future<void> sendOtp(BuildContext context) async {
    final phoneNumber = _formatPhoneNumber(phoneController.text);
    isLoading.value = true;

    try {
      if (TDeviceUtils.isDesktopScreen(context)) {
        _setupRecaptcha();
        final confirmation = await _auth.signInWithPhoneNumber(
          phoneNumber,
          _recaptchaVerifier,
        );
        desktopConfirmationResult.value = confirmation;
        Get.toNamed('/otp');
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
            await checkAndRedirectBasedOnRole();
          },
          verificationFailed: (e) {
            Get.snackbar('Error', e.message ?? 'Verification failed');
          },
          codeSent: (verId, _) {
            verificationId.value = verId;
            Get.toNamed('/otp');
          },
          codeAutoRetrievalTimeout: (verId) {
            verificationId.value = verId;
          },
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: $e');
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
        userCredential = await desktopConfirmationResult.value!.confirm(smsCode);
      } else {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: smsCode,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      if (userCredential.user != null) {
        await checkAndRedirectBasedOnRole();
      } else {
        Get.snackbar('Error', 'Verification failed. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP or verification failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAndRedirectBasedOnRole() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      final role = userDoc['role'];
      if (role == 'admin') {
        Get.offAllNamed('/dashboard');
      } else {
        Get.offAllNamed('/dashboard');
      }
    } else {
      // If first login, create with default role = driver
      await _firestore.collection('users').doc(user.uid).set({
        'mobile': user.phoneNumber,
        'role': 'driver',
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.offAllNamed('/dashboard');
    }
  }
}
