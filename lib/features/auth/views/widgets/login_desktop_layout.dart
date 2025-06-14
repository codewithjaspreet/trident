import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';
import 'package:trident/utils/constants/image_strings.dart';
import 'package:trident/utils/constants/sizes.dart';
import '../../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../../data/models/driver_model.dart';
import '../../controllers/auth_controller.dart';

class LoginDesktopLayout extends StatelessWidget {
   LoginDesktopLayout({super.key});
   final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.lg * 3, vertical: TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TRoundedContainer(
                  width: 500,
                  height: 200,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(TImages.tridentLogo),
                ),
                const SizedBox(
                  height: TSizes.lg,
                ),
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TSizes.lg),
                Text(
                  'Login to access your  account',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff313131),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TCustomInputField(
                  hintText: '+91 798521XXXX',
                  controller: authController.phoneController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  title: '',
                ),
                const SizedBox(height: TSizes.lg),
                TRoundedContainer(
                  margin: const EdgeInsets.only(top: TSizes.lg * 2),

                    onTap: () async {
                      authController.sendOtp(context);


                    },
                  backgroundColor: const Color(0xff1D61E7),
                  width: 600,
                  radius: 4,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        letterSpacing: -0.01,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          Expanded(
              child: TRoundedContainer(
            width: 300,
            height: 600,
            backgroundColor: Colors.transparent,
            child: Image.asset(TImages.login),
          )),
        ],
      ),
    );
  }
}
