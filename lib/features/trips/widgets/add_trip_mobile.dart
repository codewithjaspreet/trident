import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:trident/utils/constants/colors.dart';
import 'mobile/trip_creation_form_1.dart';
import 'mobile/trip_creation_form_2.dart';

class AddTripMobile extends StatelessWidget {
  const AddTripMobile({super.key});
  @override
  Widget build(BuildContext context) {
    final tripController = Get.put(TripController());
    final sideBarController = Get.put(SideBarController());
    return Scaffold(
      backgroundColor: TColors.white,
      body: PageView(
        controller: tripController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TripCreationFormA(
            tripController: tripController,
            sideBarController: sideBarController,
          ),
          TripCreationFormB(
            tripController: tripController,
            sideBarController: sideBarController,
          ),
        ],
      ),
    );
  }
}
