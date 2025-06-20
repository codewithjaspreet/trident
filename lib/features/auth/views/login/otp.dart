// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../controllers/auth_controller.dart';
//
// class OtpScreen extends StatelessWidget {
//   final AuthController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() => Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Enter OTP', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20.h),
//                   OtpTextField(
//                     numberOfFields: 6,
//                     borderColor: Colors.blue,
//                     showFieldAsBox: true,
//                     onCodeChanged: (String code) {},
//                     onSubmit: (String code) {
//                       controller.otpController.text = code;
//                     },
//                   ),
//                   SizedBox(height: 20.h),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         FocusScope.of(context).unfocus();
//                         if (controller.otpController.text.length != 6) {
//                           Get.snackbar('Invalid OTP', 'Please enter a 6-digit OTP');
//                           return;
//                         }
//
//                         showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (_) => const Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 CircularProgressIndicator(),
//                                 SizedBox(height: 16),
//                                 Text('Verifying OTP...', style: TextStyle(color: Colors.white)),
//                               ],
//                             ),
//                           ),
//                         );
//
//                         await controller.verifyOtp();
//                         Navigator.of(context).pop(); // Close dialog after verification
//                       },
//                       child: const Text('Verify'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (controller.isLoading.value)
//             Container(
//               color: Colors.black.withOpacity(0.4),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       )),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final AuthController controller = Get.find();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Verifying OTP',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Please wait while we verify your code...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    Navigator.of(context).pop(); // Close verification dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF48bb78), Color(0xFF38a169)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Verification Successful!',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Redirecting to dashboard...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48bb78)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Auto close after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF2D3748),
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Verify Your Phone',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter the 6-digit code sent to\n${controller.phoneController.text}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // OTP Input Section
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Verification Code',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            double spacing = 10.w;
                            double maxFieldWidth = (constraints.maxWidth - (spacing * 5)) / 6;

                            return OtpTextField(
                              numberOfFields: 6,
                              borderColor: const Color(0xFFE2E8F0),
                              focusedBorderColor: const Color(0xFF667eea),
                              enabledBorderColor: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(12.r),
                              showFieldAsBox: true,
                              fieldWidth: maxFieldWidth,

                              fieldHeight: 55.h,
                              filled: true,
                              fillColor: const Color(0xFFF7FAFC),
                              borderWidth: 2.0,
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                              ),
                              onCodeChanged: (_) => HapticFeedback.lightImpact(),
                              onSubmit: (code) {
                                controller.otpController.text = code;
                                HapticFeedback.mediumImpact();
                              },
                            );
                          },
                        ),

                        SizedBox(height: 24.h),

                        // Resend Code Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF718096),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                // Add resend OTP functionality here
                                Get.snackbar(
                                  'Code Resent',
                                  'A new verification code has been sent',
                                  backgroundColor: const Color(0xFF48bb78),
                                  colorText: Colors.white,
                                  borderRadius: 12.r,
                                  margin: EdgeInsets.all(16.w),
                                );
                              },
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF667eea),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Verify Button
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                        FocusScope.of(context).unfocus();
                        HapticFeedback.mediumImpact();

                        if (controller.otpController.text.length != 6) {
                          HapticFeedback.heavyImpact();
                          Get.snackbar(
                            'Invalid OTP',
                            'Please enter a complete 6-digit OTP',
                            backgroundColor: const Color(0xFFe53e3e),
                            colorText: Colors.white,
                            borderRadius: 12.r,
                            margin: EdgeInsets.all(16.w),
                            icon: const Icon(Icons.error_outline, color: Colors.white),
                          );
                          return;
                        }

                        _showVerificationDialog();

                        try {
                          await controller.verifyOtp();

                          // Check if verification was successful
                          if (controller.firebaseAuth.currentUser != null) {
                            _showSuccessDialog();
                          } else {
                            print('here 1');
                            Navigator.of(context).pop(); // Close verification dialog
                            HapticFeedback.heavyImpact();
                          }
                        } catch (e) {
                          print('here 2');
                          Navigator.of(context).pop(); // Close verification dialog
                          HapticFeedback.heavyImpact();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Verify & Continue',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Security Note
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FFF4),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFF9AE6B4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF48bb78),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: const Icon(
                            Icons.security,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Your information is secure and encrypted',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22543D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
