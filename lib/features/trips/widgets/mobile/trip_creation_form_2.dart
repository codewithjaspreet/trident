import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';
import '../page_controls.dart';

class TripCreationFormB extends StatelessWidget {
  const TripCreationFormB({super.key, required this.tripController, required this.sideBarController});

  final TripController tripController;
  final SideBarController sideBarController;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwItems * 4,
          horizontal: TSizes.spaceBtwItems * 2,
        ),
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: tripController.tripFormKey,
            child: Column(
              children: [
                TSectionHeading(
                  title: 'Route Details',
                  rightSideWidget: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      TImages.closeIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Source',
                  onChanged: (String? val) {
                    tripController.selectedSource.value = val!;
                  },
                  title: 'Source',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Destination',
                  onChanged: (String? val) {
                    tripController.selectedDestination.value = val!;
                  },
                  title: 'Destination',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                // make a radio button for trip type in a row

                // using google font

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Type',
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          color: Color(0xff374151),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Radio<String>(
                              value: 'OS',
                              groupValue: tripController.tripType.value,
                              onChanged: (value) {
                                tripController.tripType.value = value!;
                              },
                            )),
                        const Text('OS'),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Radio<String>(
                                value: 'Local',
                                groupValue: tripController.tripType.value,
                                onChanged: (value) {
                                  tripController.tripType.value = value!;
                                },
                              )),
                          const Text('Local'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                PageControls(
                  tripController: tripController,
                  formKey: tripController.tripFormKey,
                  sideBarController: sideBarController,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ));
  }
}
