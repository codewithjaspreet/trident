import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';

import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../page_controls.dart';

class TripCreationFormA extends StatelessWidget {
  TripCreationFormA({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  final TripController tripController;
  final SideBarController sideBarController;

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems * 2),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: TSizes.spaceBtwItems * 4,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Heading
                      TSectionHeading(
                        title: 'Add Trip',
                        rightSideWidget: !isDesktop
                            ? GestureDetector(
                          onTap: Get.back,
                          child: SvgPicture.asset(
                            TImages.closeIcon,
                            width: 24,
                            height: 24,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Row 1: Billed To
                      isDesktop
                          ? Row(
                        children: [
                          Expanded(child: _buildBilledToDropdown()),
                        ],
                      )
                          : _buildBilledToDropdown(),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Row 2: Billed Vehicle
                      isDesktop
                          ? Row(
                        children: [
                          Expanded(child: _buildBilledVehicleDropdown()),
                        ],
                      )
                          : _buildBilledVehicleDropdown(),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Driver Name
                      _buildDriverDropdown(),

                      const SizedBox(height: TSizes.spaceBtwSections * 2),
                    ],
                  ),
                ),
              ),
            ),

            /// Fixed Page Controls
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
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

  Widget _buildBilledToDropdown() {
    return TDropDown(
      items: tripController.allVendors,
      hintText: 'Billed To',
      onChanged: (String? val) {
        if (val != null) tripController.selectedBilledTo.value = val;
      },
      title: 'Billed To',
    );
  }

  Widget _buildBilledVehicleDropdown() {
    return TDropDown(
      items: tripController.allVehicles,
      hintText: 'Billed Vehicle',
      onChanged: (String? val) {
        if (val != null) tripController.selectedBilledVehicle.value = val;
      },
      title: 'Billed Vehicle',
    );
  }

  Widget _buildDriverDropdown() {
    return TDropDown(
      items: tripController.allDrivers,
      hintText: 'Driver Name',
      onChanged: (String? val) {
        if (val != null) tripController.selectedDriver.value = val;
      },
      title: 'Driver Name',
    );
  }
}
