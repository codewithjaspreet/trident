import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/data/repositories/local_repository.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';
import 'package:trident/features/dashboard/widgets/mobile/dashboard_mobile_layout.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/constants/colors.dart';
import 'package:trident/utils/device/device_utility.dart';
import '../../../common/widgets/containers/rounded_container.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class PageControls extends StatelessWidget {
  final TripController tripController;
  final SideBarController sideBarController;

  const PageControls({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);
    final isSecondPage = tripController.pageIndex.value == 1;
    return Row(
      mainAxisAlignment:
          isDesktop ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      children: [
        /// Left Button: Cancel / Previous (Mobile only or step 1 on mobile)
        if (!isDesktop)
          TRoundedContainer(
            showBorder: true,
            onTap: () {
              tripController.pageIndex.value > 0
                  ? tripController
                      .changePage(tripController.pageIndex.value - 1)
                  : Get.back();
            },
            borderColor: TColors.grey.withOpacity(0.6),
            width: 124.w,
            height: 40.h,
            radius: 8.r,
            child: Center(
              child: Text(
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: TColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                tripController.pageIndex.value == 1 ? 'Previous' : 'Cancel',
              ),
            ),
          ),

        /// Right Button: Next / Save
        TRoundedContainer(
          backgroundColor: TColors.bgPrimary,
          showBorder: true,
          onTap: ()  async{

            final userMobileNo = await GetStorage().read(
              'user_mobile_no'
            );


            if (isSecondPage) {
              final hasAllFields = tripController.selectedTripDate.isNotEmpty &&
                  tripController.selectedBilledTo.value.isNotEmpty &&
                  tripController.selectedBilledVehicle.value.isNotEmpty &&
                  tripController.selectedDriver.value.isNotEmpty &&
                  tripController.selectedSource.value.isNotEmpty &&
                  tripController.selectedDestination.value.isNotEmpty &&
                  tripController.tripType.value.isNotEmpty;



              if (hasAllFields) {


                final trip = TripModel(
                  billedTo: tripController.selectedBilledTo.value,
                  billedVehicle: tripController.selectedBilledVehicle.value,
                  driverName: tripController.selectedDriver.value,
                  source: tripController.selectedSource.value,
                  destination: tripController.selectedDestination.value,
                  status: 'Open',
                  tripDate: DateTime.parse(tripController.selectedTripDate.value).toLocal(),
                  tripType: tripController.tripType.value,
                  createdBy: userMobileNo.toString()
                );


                if (isDesktop) {
                  tripController.createTrip(trip);
                  sideBarController.menuOnTap(TRoutes.dashBoardScreen);
                  tripController.changePage(0);
                } else {
                  tripController.createTrip(trip);
                  Get.to(() => const DashboardScreen());
                }
              } else {
                Get.snackbar(
                  'Missing Information',
                  'Please fill all required fields before saving.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.black,
                );
              }
            } else {
              // Move to next page
              tripController.changePage(tripController.pageIndex.value + 1);
            }
          },
          borderColor: TColors.grey.withOpacity(0.6),
          width: 124.w,

          height: 40.h,
          radius: 8.r,
          child: Center(
            child: Text(
              style: TextStyle(
                decoration: TextDecoration.none,
                color: TColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              isSecondPage ? 'Save' : 'Next',
            ),
          ),
        ),
      ],
    );
  }
}
