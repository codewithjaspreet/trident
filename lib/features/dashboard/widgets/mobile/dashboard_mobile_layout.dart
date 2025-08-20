import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/dashboard/widgets/mobile/driver_assigned_trip_card.dart';
import 'package:trident/features/dashboard/widgets/mobile/trip_stat_item.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../trips/widgets/add_trip_mobile.dart';
import 'admin_create_trip_item.dart';

class DashboardMobileLayout extends StatelessWidget {
  DashboardMobileLayout({super.key});

  final DashBoardController dashBoardController =
  Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isLoading = dashBoardController.isLoading.value;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TSizes.lg),

              // Add Trip only for admin
              dashBoardController.loggedInUser.value.userRole == 'admin'
                  ? const AddTrip()
                  : const SizedBox.shrink(),

              // Header Row with Refresh
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dashBoardController.loggedInUser.value.userRole == 'admin'
                          ? 'All Trips'
                          : 'Assigned Trips',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                      onPressed: () async {
                        dashBoardController.isLoading.value = true;
                        final role = await GetStorage().read('user_role');
                        if (role == 'admin') {
                          await dashBoardController.getAllAdminCreatedTrips();
                        } else {
                          await dashBoardController.getAllDriverAssignedTrips();
                        }
                        dashBoardController.isLoading.value = false;
                      },
                    ),
                  ],
                ),
              ),

              if (isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Center(
                    child: Text(
                      'Pulling trips...',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ),
                )
              else if (dashBoardController.allCreatedTrips.isEmpty)
                 NoTripsPlaceholder(userRole:
                     dashBoardController
                     .loggedInUser.value.userRole)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dashBoardController.allCreatedTrips.length,
                  itemBuilder: (context, index) {
                    final trip = dashBoardController.allCreatedTrips[index];
                    return dashBoardController
                        .loggedInUser.value.userRole ==
                        'admin'
                        ? TripCard(trip: trip)
                        : DriverAssignedTripCard(trip: trip);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}

class AddTrip extends StatelessWidget {
  const AddTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const AddTripMobile(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 500));
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0272A4), Color(0xFF00B4DB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a new Trip',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select the driver and assign the trip',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoTripsPlaceholder extends StatelessWidget {
  const NoTripsPlaceholder({super.key, required this.userRole});

  final String userRole;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h, // or MediaQuery.of(context).size.height * 0.6 for responsiveness
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No Trips Found :(',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                userRole == 'admin'
                    ? 'Looks like you have not created\n any trips till now.'
                    : 'Looks like you have not been\n assigned any trips yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () async {
                  final controller = Get.find<DashBoardController>();
                  controller.isLoading.value = true;
                  final role = await GetStorage().read('user_role');
                  if (role == 'admin') {
                    await controller.getAllAdminCreatedTrips();
                  } else {
                    await controller.getAllDriverAssignedTrips();
                  }
                  controller.isLoading.value = false;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D61E7),
                  padding:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'Retry',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
