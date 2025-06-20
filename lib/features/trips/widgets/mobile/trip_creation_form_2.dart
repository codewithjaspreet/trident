import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';

import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../page_controls.dart';

class TripCreationFormB extends StatelessWidget {
  TripCreationFormB({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  final TripController tripController;
  final SideBarController sideBarController;
  final GlobalKey<FormState> tripFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems * 2),
        child: Column(
          children: [
            /// Scrollable Form
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems * 2),
              reverse: true,
              child: Form(
                key: tripFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Heading
                    TSectionHeading(
                      title: 'Route Details',
                      rightSideWidget: GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(
                          TImages.closeIcon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Source
                    TDropDown(
                      items: tripController.allSources,
                      hintText: 'Select Source',
                      onChanged: (String? val) {
                        tripController.selectedSource.value = val ?? '';
                      },
                      title: 'Source',
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Destination
                    TDropDown(
                      items: tripController.allDestination,
                      hintText: 'Select Destination',
                      onChanged: (String? val) {
                        tripController.selectedDestination.value = val ?? '';
                      },
                      title: 'Destination',
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Trip Type Label
                    Text(
                      'Trip Type',
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          color: Color(0xff374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Trip Type Radios
                    Row(
                      children: [
                        Obx(() => Radio<String>(
                          value: 'OS',
                          groupValue: tripController.tripType.value,
                          onChanged: (value) =>
                          tripController.tripType.value = value ?? '',
                        )),
                        const Text('OS'),
                        const SizedBox(width: 20),
                        Obx(() => Radio<String>(
                          value: 'Local',
                          groupValue: tripController.tripType.value,
                          onChanged: (value) =>
                          tripController.tripType.value = value ?? '',
                        )),
                        const Text('Local'),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections * 2),
                  ],
                ),
              ),
            ),

            /// Fixed Page Controls
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: TSizes.spaceBtwItems,
                  top: TSizes.spaceBtwItems,
                ),
                child: PageControls(
                  tripController: tripController,
                  sideBarController: sideBarController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
