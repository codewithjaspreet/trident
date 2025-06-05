import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';
import '../add_trip_mobile.dart';
import '../page_controls.dart';

class TripCreationFormA extends StatelessWidget {
  const TripCreationFormA({super.key, required this.dashBoardController});

  final DashBoardController dashBoardController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),

        margin: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwItems * 4,
          horizontal: TSizes.spaceBtwItems * 2,
        ),
        child: SingleChildScrollView(

          child: Form(
            key: dashBoardController.tripFormKey,
            child: Column(
              children: [
                TSectionHeading(
                  title: 'Add Trip',
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
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Trip Date',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Billed To',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Business Vertical',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'Mahindra',
                    'Tata',
                    'Maruti Suzuki',
                    'Hyundai',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Billed Vehicle',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'Mahindra',
                    'Tata',
                    'Marti Suzuki',
                    'Hyundai',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Driver Name',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                PageControls(
                  dashBoardController: dashBoardController, formKey: dashBoardController.tripFormKey,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ));
  }
}
