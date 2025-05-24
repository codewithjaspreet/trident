import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/features/dashboard/widgets/desktop/dashboard_card.dart';
import 'package:trident/utils/constants/image_strings.dart';

import '../../../../utils/constants/sizes.dart';
import 'dashboard_data_table.dart';

class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: TSizes.lg, left: TSizes.lg),
        child: Column(
          children: [
            Row(
              children: [
               const Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        DashboardCard(
                            title: 'Completed Trips',
                            iconImage: TImages.completedTrips, value: 500, percentage: '10%', updateDate: 'July 16, 2023',),
                        SizedBox(
                          width: TSizes.md,
                        ),
                        DashboardCard(
                            title: 'Active Trips',
                            iconImage: TImages.activeTrips, value: 200, percentage: '3%', updateDate: 'May 21, 2023',),
                        SizedBox(
                          width: TSizes.md,
                        ),
                        DashboardCard(

                            title: 'Created Trips',
                            iconImage: TImages.createdTrips, value: 100, percentage: '11%', updateDate: 'Aug 16, 2023',),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        TRoundedContainer(
                          height: 50,
                          width: 50,
                          backgroundColor: const Color(0xff7152F3).withOpacity(0.1),
                          child: SvgPicture.asset(TImages.calender,color: const Color(0xff7152F3)),
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        TRoundedContainer(
                          height: 50,
                          width: 50,
                          backgroundColor:const Color(0xff7152F3).withOpacity(0.1),
                          child: SvgPicture.asset(TImages.add ,color: const Color(0xff7152F3),),
                        )
                      ],
                    )),

              ],
            ),
            const Expanded(child: DashboardDataTable())

          ],
        ),
      ),
    );
  }
}
