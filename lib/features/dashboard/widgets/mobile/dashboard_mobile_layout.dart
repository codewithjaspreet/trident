
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/dashboard/views/navigation_bar.dart';
import 'package:trident/features/dashboard/widgets/mobile/review_trips_section.dart';

import 'all_trips_section.dart';

class DashboardMobileLayout extends StatelessWidget {
  DashboardMobileLayout({super.key});

  final DashBoardController dashBoardController = Get.put(DashBoardController());
  final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return navigationController.currentIndex.value == 0
            ? AllTrips(
          dashBoardController: dashBoardController,
          navigationController: navigationController,
        )
            :  ReviewTripsSection(
          dashboardController: dashBoardController,
          navigationController: navigationController,
        );
      }),
    );
  }
}
