import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';

import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
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
    final isTablet = MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width < 1024;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Main scrollable content
              Positioned.fill(
                child: CustomScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : 20,
                        vertical: 20,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(width: TSizes.lg),
                              _buildHeader(isDesktop),
                              const SizedBox(height: TSizes.spaceBtwSections * 1.5),
                              _buildFullWidthDropdown(
                                dropdown: TDropDown(
                                  items: tripController.allVendors,
                                  hintText: 'Select vendor to bill',
                                  onChanged: (String? val) {
                                    if (val != null) tripController.selectedBilledTo.value = val;
                                  },
                                  title: 'Billed To',
                                ),
                                icon: Icons.business,
                                iconColor: Colors.green.shade500,
                                label: 'Billed To',
                              ),
                              SizedBox(height: TSizes.spaceBtwSections),
                              _buildFullWidthDropdown(
                                dropdown: TDropDown(
                                  items: tripController.allVehicles,
                                  hintText: 'Select vehicle for trip',
                                  onChanged: (String? val) {
                                    if (val != null) tripController.selectedBilledVehicle.value = val;
                                  },
                                  title: 'Billed Vehicle',
                                ),
                                icon: Icons.directions_car,
                                iconColor: Colors.orange.shade500,
                                label: 'Billed Vehicle',
                              ),
                              SizedBox(height: TSizes.spaceBtwSections),
                              _buildFullWidthDropdown(
                                dropdown: TDropDown(
                                  items: tripController.allDrivers,
                                  hintText: 'Select trip driver',
                                  onChanged: (String? val) {
                                    if (val != null) tripController.selectedDriver.value = val;
                                  },
                                  title: 'Driver Name',
                                ),
                                icon: Icons.person,
                                iconColor: Colors.blue.shade500,
                                label: 'Driver Name',
                              ),
                              SizedBox(height: 160), // add more space so scroll isn't clipped
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed bottom controls
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildFixedBottomControls(isDesktop),
              ),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade500,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_road_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Trip',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in the trip details below',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (!isDesktop)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: Get.back,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      TImages.closeIcon,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade600,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullWidthDropdown({
    required Widget dropdown,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              letterSpacing: -0.2,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: dropdown),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFixedBottomControls(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              PageControls(
                tripController: tripController,
                sideBarController: sideBarController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}