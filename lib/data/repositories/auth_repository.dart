import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> loginWithPhone(String phoneNumber);
  Future<void> verifyOTP(String verificationId, String smsCode);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getUserRole();
  String? get verificationId;
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  @override
  String? get verificationId => _verificationId;

  @override
  Future<void> loginWithPhone(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("🔴 verificationFailed: ${e.message}");
          throw Exception('Phone verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print("✅ codeSent: verificationId = $verificationId");
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("⌛ codeAutoRetrievalTimeout: $verificationId");
          _verificationId = verificationId;
        },
      );
    } catch (e, st) {
      print('🔥 Caught error during phone login: $e');
      print('📌 Stack trace: $st');
      rethrow; // optional, or handle gracefully
    }
  }

  @override
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User ID not found after sign-in");

      final userDoc = _firestore.collection('users').doc(uid);
      final exists = (await userDoc.get()).exists;

      if (!exists) {
        await userDoc.set({
          'phone': _auth.currentUser?.phoneNumber,
          'role': 'driver', // Default role
        });
      }
    } catch (e) {
      print("❌ OTP verification failed: $e");
      throw Exception("OTP verification failed: $e");
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<String?> getUserRole() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'];
  }
}
