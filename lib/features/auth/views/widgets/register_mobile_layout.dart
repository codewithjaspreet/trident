import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/features/auth/views/widgets/login_mobile_layout.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';
import 'package:trident/features/dashboard/widgets/mobile/dashboard_mobile_layout.dart';
import 'package:trident/utils/constants/image_strings.dart';
import 'package:trident/utils/constants/sizes.dart';
import '../../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class RegisterMobileLayout extends StatelessWidget {
  const RegisterMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              bottom: MediaQuery.of(context).viewInsets.bottom ,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TRoundedContainer(
                  backgroundColor: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: TSizes.lg * 3),
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
                  margin: const EdgeInsets.symmetric(horizontal: TSizes.lg),
                  child: Column(
                    children: [
                    Row(
                      children: [
                        Positioned(
                          top: 50.h, // adjust based on your UI
                          left: 16.w,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87, // or white if background is dark
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: TextStyle(
                              color: const Color(0xff6C7278),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: TSizes.sm),
                          GestureDetector(
                            onTap: (){
                              Get.to( LoginMobileLayout()
                              , transition: Transition.rightToLeft
                              );
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: const Color(0xff4D81E7),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.lg),
                    Row(
                      children: [
                        Expanded(child: TRoundedContainer(
                          child: TCustomInputField(
                            hintText: 'Lois',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            title: 'First Name',
                          ),
                        ),),
                       Expanded(child:  TRoundedContainer(
                         child: TCustomInputField(
                           hintText: 'Becket',
                           validator: (value) => value == null || value.isEmpty
                               ? 'Required'
                               : null,
                           keyboardType: TextInputType.visiblePassword,
                           textInputAction: TextInputAction.done,
                           title: 'Last Name',
                         ),
                       ),)
                      ],
                    ),
                      TRoundedContainer(
                        child: TCustomInputField(
                          hintText: 'Loisbecket@gmail.com',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          title: 'Email',
                        ),
                      ),
                      TRoundedContainer(
                        child: TCustomInputField(
                          hintText: '********',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          title: 'Birth Date',
                        ),
                      ),

                      TRoundedContainer(
                        child: TCustomInputField(
                          hintText: '********',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          title: 'Ser Password',
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: TSizes.lg),

                      TRoundedContainer(
                        onTap: () => Get.to(const DashboardScreen(),transition: Transition.leftToRight),
                        margin:
                        const EdgeInsets.symmetric(horizontal: TSizes.md),
                        backgroundColor: const Color(0xff1D61E7),
                        width: 290.w,
                        height: 50.h,
                        child: Center(
                          child: Text(
                            'Register',
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
    );
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
