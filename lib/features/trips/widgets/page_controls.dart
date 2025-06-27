import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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
import '../../../data/models/trip_stage_model.dart';
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
          Container(
            width: 100.w,
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(
                color: TColors.grey.withOpacity(0.6),
              ),
            ),
            margin: EdgeInsets.only(left: 16.w),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  tripController.pageIndex.value > 0
                      ? tripController
                          .changePage(tripController.pageIndex.value - 1)
                      : Get.back();
                },
                child: Text(
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: TColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  tripController.pageIndex.value == 1 ? 'Previous' : 'Cancel',
                ),
              ),
            ),
          ),

        /// Right Button: Next / Save
        ///
        ///
        ///
        Container(
          width: 100.w,
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color:TColors.bgPrimary,
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(
              color: TColors.grey.withOpacity(0.6),
            ),
          ),
          margin: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () async {
                final userMobileNo = await GetStorage().read('user_mobile_no');
                final pageIndex = tripController.pageIndex.value;
                final missingFields = <String>[];

// Page 1 validations
                if (pageIndex == 0) {
                  if (tripController.selectedBilledTo.value.isEmpty) {
                    missingFields.add('Billed To');
                  }
                  if (tripController.selectedBilledVehicle.value.isEmpty) {
                    missingFields.add('Billed Vehicle');
                  }
                  if (tripController.selectedDriver.value.isEmpty) {
                    missingFields.add('Driver Name');
                  }

                  if (missingFields.isNotEmpty) {
                    Get.snackbar(
                      'Missing Information',
                      'Please select: ${missingFields.join(', ')}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.black,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                    );
                    return;
                  }

// All good → move to next page
                  tripController.changePage(1);
                  return;
                }

// Page 2 validations
                if (pageIndex == 1) {
                  if (tripController.selectedSource.value.isEmpty) {
                    missingFields.add('Source');
                  }
                  if (tripController.selectedDestination.value.isEmpty) {
                    missingFields.add('Destination');
                  }
                  if (tripController.tripType.value.isEmpty) {
                    missingFields.add('Trip Type');
                  }

                  if (missingFields.isNotEmpty) {
                    Get.snackbar(
                      'Missing Information',
                      'Please select: ${missingFields.join(', ')}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.black,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                    );
                    return;
                  }

// All good → Save
                  final trip = TripModel(
                    billedTo: tripController.selectedBilledTo.value,
                    billedVehicle: tripController.selectedBilledVehicle.value,
                    driverName: tripController.selectedDriver.value,
                    source: tripController.selectedSource.value,
                    destination: tripController.selectedDestination.value,
                    status: 'Open',
                    tripType: tripController.tripType.value,
                    completedAt: null,
                    createdBy: userMobileNo.toString(),
                    stages: [
                      TripStageModel(name: 'Loading'),
                      TripStageModel(name: 'Loaded'),
                      TripStageModel(name: 'Dispatched'),
                    ],
                  );

                  tripController.createTrip(trip);

                  if (isDesktop) {
                    sideBarController.menuOnTap(TRoutes.dashBoardScreen);
                    tripController.changePage(0);
                  } else {
                    Get.to(() => const DashboardScreen());
                  }
                }
              },
              child: Text(
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: TColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
                isSecondPage ? 'Save' : 'Next',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
