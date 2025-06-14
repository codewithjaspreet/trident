import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter OTP',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              TextField(
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '6-digit OTP',
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.verifyOtp,
                        child: const Text('Verify'),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
