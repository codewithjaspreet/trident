import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/utils/constants/image_strings.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/auth_controller.dart';

class LoginMobileLayout extends StatelessWidget {
  LoginMobileLayout({super.key});

  final AuthController authController = Get.put(AuthController());
  static const Color bgPrimary = Color(0xff515DEF);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // Top section with logo
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo without container background
                        SizedBox(
                          width: 180.w,
                          height: 120.w,
                          child: Image.asset(
                            TImages.tridentLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom section with form
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff1a1a2e),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),
                        
                            // Welcome text
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xff515DEF),
                                  Color(0xff7C3AED),
                                  Color(0xffF59E0B),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'Welcome Back',
                                style: GoogleFonts.outfit(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        
                            SizedBox(height: 8.h),
                        
                            Text(
                              'Sign in to continue your journey',
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        
                            SizedBox(height: 32.h),
                        
                            // Modern divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    'Enter your phone',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        
                            SizedBox(height: 32.h),
                        
                            // Phone input field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                                  child: Text(
                                    'Phone Number',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    color: Colors.white.withOpacity(0.08),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.15),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: authController.phoneController,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '+91 798521XXXX',
                                      hintStyle: GoogleFonts.outfit(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 18.h,
                                      ),
                                    ),
                                    validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                        
                            SizedBox(height: 32.h),
                        
                            // Login button
                            Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28.r),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff515DEF),
                                    Color(0xff7C3AED),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: bgPrimary.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28.r),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    final phone = authController.phoneController.text.trim();
                        
                                    if (phone.isEmpty || phone.length < 10) {
                                      Get.snackbar('Invalid Input', 'Please enter a valid mobile number');
                                      return;
                                    }
                        
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => Container(
                                        color: Colors.black.withOpacity(0.8),
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(32.w),
                                            margin: EdgeInsets.symmetric(horizontal: 32.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.r),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
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
                                                    shape: BoxShape.circle,
                                                    color: bgPrimary.withOpacity(0.1),
                                                  ),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      color: bgPrimary,
                                                      strokeWidth: 3,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 24.h),
                                                Text(
                                                  'Sending OTP...',
                                                  style: GoogleFonts.outfit(
                                                    color: const Color(0xff1a1a2e),
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  'Please wait a moment',
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                        
                                    await authController.sendOtp(context);
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.login_rounded,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Continue',
                                          style: GoogleFonts.outfit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        
                            SizedBox(height: 24.h),
                        
                            // Footer text
                            Text(
                              'By continuing, you agree to our Terms & Privacy Policy',
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Modern Loading Overlay
          if (authController.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(32.w),
                  margin: EdgeInsets.symmetric(horizontal: 32.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
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
                          shape: BoxShape.circle,
                          color: bgPrimary.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: bgPrimary,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Processing...',
                        style: GoogleFonts.outfit(
                          color: const Color(0xff1a1a2e),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class DividerComponent extends StatelessWidget {
  const DividerComponent({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (isDark ? TColors.darkGrey : TColors.grey).withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            dividerText,
            style: GoogleFonts.outfit(
              color: isDark ? TColors.darkGrey : TColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (isDark ? TColors.darkGrey : TColors.grey).withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}