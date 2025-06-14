import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trident/common/widgets/images/t_circular_image.dart';
import 'package:trident/common/widgets/layouts/sidebars/sidebar_menu_item.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/constants/colors.dart';
import 'package:trident/utils/constants/enums.dart';
import 'package:trident/utils/device/device_utility.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class TSideBar extends StatelessWidget {
  const TSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(


        margin: TDeviceUtils.isMobileScreen(context) ?  const EdgeInsets.symmetric(vertical: TSizes.lg * 3) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: TColors.white,
          border: Border(
            right: BorderSide(
              color: TColors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                TImages.appLogo,
                height: 70,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
               Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TMenuItem(
                      icon: TImages.dashboard,
                      route: TRoutes.dashBoardScreen,
                      menuName: 'Dashboard',
                    ),
                    const TMenuItem(
                      icon: TImages.completedTrips,
                      route: TRoutes.completedTripsScreen,
                      menuName: 'Completed Trips',
                    ),
                    const TMenuItem(
                      icon: TImages.activeTrips,
                      route: TRoutes.activeTripsScreen,
                      menuName: 'Active Trips',
                    ),
                    const TMenuItem(
                      icon: TImages.createdTrips,
                      route: TRoutes.createdTripsScreen,
                      menuName: 'Created Trips',
                    ),

                   ! TDeviceUtils.isMobileScreen(context) ? const TMenuItem(
                      icon: TImages.addTrips,
                      route: TRoutes.addTripsScreen,
                      menuName: 'Add Trips',
                    ) :  const SizedBox.shrink(),
                    // TMenuItem(icon: TImages.notes, route: TRoutes.notesScreen, menuName: 'Notes',),
                    // TMenuItem(icon: TImages.holidays, route: TRoutes.holidaysScreen, menuName: 'Holidays',),
                    const TMenuItem(
                      icon: TImages.appSettings,
                      route: TRoutes.appSettingsScreen,
                      menuName: 'Settings',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
