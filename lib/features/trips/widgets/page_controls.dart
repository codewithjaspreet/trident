import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/device/device_utility.dart';
import '../../../data/models/trip_stage_model.dart';

class PageControls extends StatelessWidget {
  final TripController tripController;
  final SideBarController sideBarController;
  static const Color bgPrimary = Color(0xff515DEF);

  const PageControls({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);

    return Obx(() {
      final currentPage = tripController.pageIndex.value;

      return Row(
        mainAxisAlignment: isDesktop ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
        children: [
          /// Left Button: Cancel / Previous (Mobile only or step 1 on mobile)
          if (!isDesktop)
            _buildLeftButton(currentPage),

          /// Right Button: Next / Continue / Save
          _buildRightButton(currentPage, isDesktop),
        ],
      );
    });
  }

  Widget _buildLeftButton(int currentPage) {
    return Container(
      width: 100.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            if (currentPage > 0) {
              tripController.changePage(currentPage - 1);
            } else {
              Get.back();
            }
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentPage > 0)
                  Icon(
                    Icons.arrow_back_ios,
                    size: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                if (currentPage > 0) SizedBox(width: 4.w),
                Text(
                  _getLeftButtonText(currentPage),
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightButton(int currentPage, bool isDesktop) {
    return Container(
      width: currentPage == 2 ? 120.w : 100.w, // Wider for "Create Trip"
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff515DEF),
            Color(0xff7C3AED),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: bgPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () => _handleRightButtonTap(currentPage, isDesktop),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getRightButtonText(currentPage),
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  currentPage == 2 ? Icons.check_circle : Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLeftButtonText(int currentPage) {
    switch (currentPage) {
      case 0:
        return 'Cancel';
      case 1:
        return 'Previous';
      case 2:
        return 'Previous';
      default:
        return 'Cancel';
    }
  }

  String _getRightButtonText(int currentPage) {
    switch (currentPage) {
      case 0:
        return 'Next';
      case 1:
        return 'Continue';
      case 2:
        return 'Create Trip';
      default:
        return 'Next';
    }
  }

  Future<void> _handleRightButtonTap(int currentPage, bool isDesktop) async {
    final userMobileNo = await GetStorage().read('user_mobile_no');
    final missingFields = <String>[];

    // Page 1 validations (Trip Details)
    if (currentPage == 0) {
      if (!tripController.validateStepOne()) {
        if (tripController.selectedTripDate.value == null) {
          missingFields.add('Trip Date');
        }
        if (tripController.selectedBilledTo.value.isEmpty) {
          missingFields.add('Billed To');
        }
        if (tripController.selectedBilledVehicle.value.isEmpty) {
          missingFields.add('Billed Vehicle');
        }


        _showValidationError(missingFields);
        return;
      }

      // Move to page 2
      tripController.changePage(1);
      return;
    }

    // Page 2 validations (Route Details)
    if (currentPage == 1) {
      // Validate required fields for step 2
      if (tripController.selectedSource.value.isEmpty) {
        missingFields.add('Source');
      }

      if (tripController.selectedConsignor.value.isEmpty) {
        missingFields.add('Consignor (Auto-filled based on consignee)');
      }
      if (tripController.selectedDestination.value.isEmpty) {
        missingFields.add('Destination (Auto-filled based on consignee)');
      }
      if (tripController.tripType.value.isEmpty) {
        missingFields.add('Trip Type');
      }
      if (tripController.selectedDriver.value.isEmpty) {
        missingFields.add('Driver Name');
      }

      if (missingFields.isNotEmpty) {
        _showValidationError(missingFields);
        return;
      }

      // Move to page 3 (Stage Configuration)
      tripController.changePage(2);
      return;
    }

    // Page 3 - Final Save (Stage Configuration Complete)
    if (currentPage == 2) {
      // Validate that at least one stage is defined
      if (tripController.customStages.isEmpty) {
        Get.snackbar(
          'No Stages Defined',
          'Please define at least one stage for the trip workflow',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        );
        return;
      }

      // Show loading indicator
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: bgPrimary),
                SizedBox(height: 16.h),
                Text(
                  'Creating Trip...',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      try {
        // Convert custom stages to TripStageModel
        final stageModels = tripController.customStages.map((stage) {
          return TripStageModel(
            name: stage.name,
            isCompleted: false,
            completedAt: null,
          );
        }).toList();

        // Create the trip with all collected data including consignee reference
        final trip = TripModel(
          tripDate: tripController.selectedTripDate.value,
          billedTo: tripController.selectedBilledTo.value,
          billedVehicle: tripController.selectedBilledVehicle.value,
          driverName: tripController.selectedDriver.value,
          source: tripController.selectedSource.value,
          destination: tripController.selectedDestination.value,
          status: 'Open', // First stage status
          tripType: tripController.tripType.value,
          completedAt: null,
          createdBy: userMobileNo?.toString() ?? '',
          consignor: tripController.selectedConsignor.value,
          stages: stageModels,
          consignee: tripController.selectedConsignee.value.value,
        );

        // Save the trip
        await tripController.createTrip(trip);

        // Close loading dialog
        Get.back();

        // Show success message
        Get.snackbar(
          'Trip Created Successfully!',
          '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          duration: const Duration(seconds: 4),
        );

        // Clear the form
        tripController.clearTripForm();

        // Navigate back to dashboard
        if (isDesktop) {
          sideBarController.menuOnTap(TRoutes.dashBoardScreen);
          tripController.changePage(0);
        } else {
          Get.off(() => const DashboardScreen());
          tripController.changePage(0);
        }

      } catch (e) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          'Error Creating Trip',
          'Failed to create trip: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          duration: const Duration(seconds: 4),
        );

        print('Error creating trip: $e');
      }
    }
  }

  void _showValidationError(List<String> missingFields) {
    Get.snackbar(
      'Missing Information',
      'Please complete: ${missingFields.join(', ')}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      duration: const Duration(seconds: 4),
    );
  }
}