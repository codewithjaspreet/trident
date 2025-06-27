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
  final TripController tripController;
  final SideBarController sideBarController;

  const TripCreationFormA({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// Scrollable content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems * 2),
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                  top: isDesktop ? 0 : TSizes.spaceBtwItems * 2,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120.h,
                ),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TSectionHeading(
                        title: 'Add Trip',
                        rightSideWidget: !isDesktop
                            ? GestureDetector(
                          onTap: Get.back,
                          child: SvgPicture.asset(
                            TImages.closeIcon,
                            width: 24.w,
                            height: 24.h,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      isDesktop
                          ? Row(children: [Expanded(child: _buildBilledToDropdown())])
                          : _buildBilledToDropdown(),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      isDesktop
                          ? Row(children: [Expanded(child: _buildBilledVehicleDropdown())])
                          : _buildBilledVehicleDropdown(),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      _buildDriverDropdown(),
                      const SizedBox(height: TSizes.spaceBtwSections * 2),
                    ],
                  ),
                ),
              ),
            ),

            /// Fixed Page Controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.spaceBtwItems * 2,
                  vertical: TSizes.spaceBtwItems,
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
