import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/common/widgets/images/t_rounded_image.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/constants/colors.dart';
import 'package:trident/utils/constants/enums.dart';
import 'package:trident/utils/constants/image_strings.dart';
import 'package:trident/utils/constants/sizes.dart';
import 'package:trident/utils/device/device_utility.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = TDeviceUtils.isMobileScreen(context);
    SideBarController sideBarController = Get.put(SideBarController());

    // ------------------- MOBILE APPBAR -------------------
    if (isMobile) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              TSizes.md, TSizes.md, TSizes.md, TSizes.sm),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo

                Image.asset(
                  TImages.appLogo,
                  height: 70,
                ),
                // const SizedBox(width: TSizes.lg),
                // const Icon(Icons.search,
                //     size: TSizes.md * 2, color: TColors.secondary),
                // const SizedBox(width: TSizes.lg),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offNamed(TRoutes.loginScreen),
                        child: const Icon(Iconsax.logout)),
                    //     size: TSizes.md * 2, color: TColors.secondary),
                    const SizedBox(width: TSizes.md ),
                    InkWell(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.1.0',
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    // ------------------- DESKTOP / TABLET HEADER -------------------
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      height: preferredSize.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting Text
          Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (sideBarController.activeItem.value == '/dashboard') ...[
                  Text(
                    'Hello Robert 👋🏻',
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      color: TColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Good Morning',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: TColors.primary,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Add New Trip',
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      color: TColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Search Box
          // SizedBox(
          //   width: 300,
          //   child: TextFormField(
          //     decoration: InputDecoration(
          //       hintText: 'Search',
          //       prefixIcon: const Icon(Icons.search),
          //       hintStyle: GoogleFonts.lexend(
          //         fontSize: 14,
          //         color: Colors.black54,
          //         fontWeight: FontWeight.w300,
          //       ),
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: const BorderSide(color: TColors.primary),
          //       ),
          //     ),
          //   ),
          // ),

          // const SizedBox(width: TSizes.lg),
          //
          // // Notification Icon
          // TRoundedImage(
          //   width: 50,
          //   height: 50,
          //   borderRadius: 10,
          //   backgroundColor: TColors.primary.withOpacity(0.10),
          //   imageType: ImageType.asset,
          //   image: TImages.notification,
          //   fit: BoxFit.contain,
          // ),

          const SizedBox(width: TSizes.lg),

          GestureDetector(
              onTap: () => Get.offAll(TRoutes.loginScreen),
              child: const Icon(Iconsax.logout)),
          // Profile Card
          TRoundedContainer(
            width: 184,
            height: 50,
            radius: 10,
            borderColor: TColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                // const TRoundedImage(
                //   image:
                //       'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.1.0',
                //   width: 40,
                //   height: 40,
                //   fit: BoxFit.fitHeight,
                //   borderRadius: TSizes.md,
                //   imageType: ImageType.network,
                // ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Robert Allen',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        color: TColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
