


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
   TripCreationFormA({super.key, required this.tripController, required this.sideBarController});

  final TripController tripController;
  final SideBarController sideBarController;



  @override
  Widget build(BuildContext context) {
    final isDeskTop = TDeviceUtils.isDesktopScreen(context);

    return Container(
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      margin: const EdgeInsets.symmetric(
        vertical: TSizes.spaceBtwItems * 4,
        horizontal: TSizes.spaceBtwItems * 2,
      ),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              TSectionHeading(
                title: 'Add Trip',
                rightSideWidget: isDeskTop ? const SizedBox.shrink() :   GestureDetector(
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

              /// Row 1: Trip Date + Billed To
              isDeskTop
                  ? Row(
                children: [
                   Expanded(child: DeliveryDatePicker(tripController: tripController,)),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TDropDown(
                      items: const [
                        'Mother Dairy',
                        'Amul',
                        'Namaste India',
                        'Havmor',
                        'Vadilal',
                        'Oriental ',
                        'Scootsy ',
                        'Bhagavati ',
                      ],
                      hintText: 'Billed To',
                      onChanged: (String? val) {
                        tripController.selectedBilledTo.value = val!;
                      },
                      title: 'Billed To',
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  TDropDown(
                    items: const [
                      'Mother Dairy',
                      'Amul',
                      'Namaste India',
                      'Havmor',
                      'Vadilal',
                      'Oriental ',
                      'Scootsy ',
                      'Bhagavati ',
                    ],
                    hintText: 'Billed To',
                    onChanged: (String? val) {
                      tripController.selectedBilledTo.value = val!;

                    },
                    title: 'Billed To',
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Row 2: Business Vertical + Billed Vehicle
              isDeskTop
                  ? Row(
                children: [
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TDropDown(
                      items: tripController.allVehicles,
                      hintText: 'Billed Vehicle',
                      onChanged: (String? val) {
                        tripController.selectedBilledVehicle.value = val!;

                      },
                      title: 'Billed Vehicle',
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  TDropDown(
                    items: tripController.allVehicles,
                    hintText: 'Billed Vehicle',
                    onChanged: (String? val) {
                      tripController.selectedBilledVehicle.value = val!;
                    },
                    title: 'Billed Vehicle',
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Driver Name (full width both layouts)
              TDropDown(
                items: tripController.allDrivers,
                hintText: 'Driver Name',
                onChanged: (String? val) {
                  tripController.selectedDriver.value = val!;

                },
                title: 'Driver Name',
              ),
              const SizedBox(height: TSizes.spaceBtwSections ),

              /// Page Controls
              PageControls(
                tripController: tripController,
                sideBarController: sideBarController,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliveryDatePicker extends StatelessWidget {
   const DeliveryDatePicker({super.key, required this.tripController});

  final TripController tripController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trip Date',
            style: TextStyle(
              color: TColors.primary,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 24 / 16,
            )),
        SizedBox(height: 8.h),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_month),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0.r),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0.r),
              borderSide: const BorderSide(
                color: TColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            hintText: 'Trip Date',
            hintStyle: GoogleFonts.nunitoSans(
              textStyle: const TextStyle(
                color: TColors.primary,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                fontSize: 14,
                height: 24 / 14,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: 11.sp,
              color: TColors.primary,
            ),
          ),
          readOnly: true,
          onTap: () async {
            DateTime now = DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day);

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: today,
              firstDate: today,
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              // TODO: Update the controller or field with selected date

              tripController.selectedTripDate.value = pickedDate.toString();

              print("Selected date: $formattedDate");
            }
          },
        ),
      ],
    );
  }
}
