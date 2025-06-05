import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/utils/constants/colors.dart';
import 'mobile/trip_creation_form_1.dart';
import 'mobile/trip_creation_form_2.dart';

class AddTripMobile extends StatelessWidget {
  const AddTripMobile({super.key});
  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashBoardController());
    return Scaffold(
      backgroundColor: TColors.white,
      body: PageView(
        controller: dashboardController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TripCreationFormA(
            dashBoardController: dashboardController,
          ),
          TripCreationFormB(
            dashBoardController: dashboardController,
          ),
        ],
      ),
    );
  }
}
