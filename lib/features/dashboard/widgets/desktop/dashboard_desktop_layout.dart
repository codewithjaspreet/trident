import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/dashboard/widgets/desktop/dashboard_card.dart';
import 'package:trident/features/trips/widgets/add_trip_desktop.dart';
import 'package:trident/utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'dashboard_data_table.dart';

class DashboardDesktopLayout extends StatelessWidget {
  DashboardDesktopLayout({super.key});

  final SideBarController sideBarController = Get.put(SideBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: TSizes.lg,
          left: TSizes.lg,
          right: TSizes.lg,
        ),
        child: Column(
          children: [
            /// TOP BAR with cards
            Obx(() {
              if (sideBarController.activeItem.value == '/dashboard') {
                return const Row(
                  children: [
                    DashboardCard(
                      title: 'Completed Trips',
                      iconImage: TImages.completedTrips,
                      value: 500,
                      percentage: '10%',
                      updateDate: 'July 16, 2023',
                    ),
                    SizedBox(width: TSizes.md),
                    DashboardCard(
                      title: 'Active Trips',
                      iconImage: TImages.activeTrips,
                      value: 200,
                      percentage: '3%',
                      updateDate: 'May 21, 2023',
                    ),
                    SizedBox(width: TSizes.md),
                    DashboardCard(
                      title: 'Created Trips',
                      iconImage: TImages.createdTrips,
                      value: 100,
                      percentage: '11%',
                      updateDate: 'Aug 16, 2023',
                    ),
                  ],
                );
              } else {
                return const SizedBox(); // Hide cards if not dashboard
              }
            }),

            const SizedBox(height: TSizes.md),

            /// MAIN BODY based on selected route
            Expanded(
              child: Obx(() {
                switch (sideBarController.activeItem.value) {
                  case '/addTrips':
                    return  AddTripDesktop();
                  case '/dashboard':
                  default:
                    return const DashboardDataTable();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
