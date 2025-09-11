import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';

class TridentNavigationBar extends StatelessWidget {
  TridentNavigationBar({super.key});

  DashBoardController dashBoardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: _buildCurrentScreen(controller.currentIndex.value),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changeIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue[700],
                unselectedItemColor: Colors.grey[600],
                elevation: 8,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                items:  [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.local_shipping_outlined),
                    activeIcon: Icon(Icons.local_shipping),
                    label: 'All Trips',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.rate_review_outlined),
                    activeIcon: const  Icon(Icons.rate_review),
                    label:GetStorage().read('user_role') == 'driver' ? 'Insights' : 'Review Trips',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return  const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }
}

// Placeholder controller - you can replace this with your own
class NavigationController extends GetxController {
  // reactive variable to hold the current index
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;

    DashBoardController controller = Get.find<DashBoardController>();
    if (index == 0) {
      controller.getAllCreatedTrips();
    } else if (index == 1) {
      controller.getAllReviewingTrips();
    }
  }
}
