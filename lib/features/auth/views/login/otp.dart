import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Enter OTP', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.h),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Colors.blue,
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String code) {
                      controller.otpController.text = code;
                    },
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (controller.otpController.text.length != 6) {
                          Get.snackbar('Invalid OTP', 'Please enter a 6-digit OTP');
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Verifying OTP...', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        );

                        await controller.verifyOtp();
                        Navigator.of(context).pop(); // Close dialog after verification
                      },
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      )),
    );
  }
}
