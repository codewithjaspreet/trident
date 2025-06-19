import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/utils/constants/image_strings.dart';
import 'package:trident/utils/constants/sizes.dart';
import '../../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/auth_controller.dart';

class LoginMobileLayout extends StatelessWidget {
  LoginMobileLayout({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                // Background Gradient
                const TRoundedContainer(
                  width: double.infinity,
                  height: double.infinity,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0XFFA49EF4),
                      Color(0XFF94BCEB),
                      Colors.white,
                    ],
                  ),
                ),

                // Foreground Login Form
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TRoundedContainer(
                        backgroundColor: Colors.transparent,
                        margin:
                        const EdgeInsets.symmetric(vertical: TSizes.lg * 3),
                        radius: 0,
                        width: 300.w,
                        height: 80.h,
                        child: Image.asset(
                          TImages.tridentLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      TRoundedContainer(
                        width: double.infinity,
                        margin:
                        const EdgeInsets.symmetric(horizontal: TSizes.lg),
                        child: Column(
                          children: [
                            Text(
                              'Get Started now',
                              style: GoogleFonts.inter(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF4983F6),
                                      Color(0xFFC175F5),
                                      Color(0xFFFBACB7),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                              ),
                            ),
                            const SizedBox(height: TSizes.sm),
                            Text(
                              'Create an account or log in to explore our app',
                              style: GoogleFonts.inter(
                                color: const Color(0xff6C7278),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: TSizes.lg),
                            const DividerComponent(dividerText: 'Or'),
                            const SizedBox(height: TSizes.lg),
                            TRoundedContainer(
                              child: TCustomInputField(
                                hintText: '+91 798521XXXX',
                                controller: authController.phoneController,
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                title: 'Phone No.',
                              ),
                            ),
                            const SizedBox(height: TSizes.lg),
                            TRoundedContainer(
                              onTap: () async {
                                authController.sendOtp(context);
                              },
                              margin: const EdgeInsets.symmetric(
                                  horizontal: TSizes.md),
                              backgroundColor: const Color(0xff1D61E7),
                              width: 290.w,
                              height: 50.h,
                              child: Center(
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    letterSpacing: -0.01,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: TSizes.lg),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Centered Loading Overlay
          if (authController.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
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
          child: Divider(
            color: isDark ? TColors.darkGrey : TColors.grey,
            endIndent: 5,
            thickness: 0.5,
            indent: 40,
          ),
        ),
        Text(
          dividerText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Flexible(
          child: Divider(
            thickness: 0.5,
            color: isDark ? TColors.darkGrey : TColors.grey,
            endIndent: 40,
            indent: 5,
          ),
        ),
      ],
    );
  }
}
