// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:trident/common/widgets/containers/rounded_container.dart';
// import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
// import 'package:trident/features/dashboard/widgets/mobile/trip_stat_item.dart';
// import '../../../../data/models/trip_model.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../trips/widgets/add_trip_mobile.dart';
// import 'admin_create_trip_item.dart';
// import 'filter_options.dart';
//
// class DashboardMobileLayout extends StatelessWidget {
//    DashboardMobileLayout({super.key});
//
//   DashBoardController dashBoardController  = Get.put(DashBoardController());
//
//   @override
//   Widget build(BuildContext context) {
//     // final List<ChartData> chartData = [
//     //   ChartData('Completed', 66, const Color(0xff0791F8)), // blue
//     //   ChartData('Remaining', 34, const Color(0xffD6ECFD)), // light gra
//     // ];
//
//     return Scaffold(
//       body: CustomRefreshIndicator(
//         onRefresh: () async {
//
//           final loggedInUserRole = await GetStorage().read('user_role');
//           loggedInUserRole == 'admin' ? dashBoardController.getAllAdminCreatedTrips() : dashBoardController.getAllDriverAssignedTrips()
//         },
//         builder: (BuildContext context, Widget child, IndicatorController controller) {
//
//          controller : indicatorBuilder: (context, controller) {
//            return Padding(
//              padding: const EdgeInsets.all(6.0),
//              child: CircularProgressIndicator(
//                color: Colors.redAccent,
//                value: controller.state.isLoading ? null : math.min(controller.value, 1.0),
//              ),
//            );
//          },
//         },
//
//         child:   SingleChildScrollView(
//       child: Column(
//       mainAxisSize: MainAxisSize.min,
//         children: [
//           // const Row(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [FilterOption()],
//           // ),
//           // Row(
//           //   crossAxisAlignment: CrossAxisAlignment.start,
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [
//           //     Expanded(
//           //       flex: 5,
//           //       child: TRoundedContainer(
//           //         backgroundColor: Colors.transparent,
//           //         width: 200,
//           //         height: 200,
//           //         child: SfCircularChart(
//           //           margin: EdgeInsets.zero,
//           //           annotations: const <CircularChartAnnotation>[
//           //             CircularChartAnnotation(
//           //               widget: Text(
//           //                 '66%',
//           //                 style: TextStyle(
//           //                   fontSize: 24,
//           //                   fontWeight: FontWeight.w600,
//           //                   color: Color(0xff374151),
//           //                 ),
//           //               ),
//           //             )
//           //           ],
//           //           series: <CircularSeries>[
//           //             DoughnutSeries<ChartData, String>(
//           //               dataSource: chartData,
//           //               xValueMapper: (ChartData data, _) => data.x,
//           //               yValueMapper: (ChartData data, _) => data.y,
//           //               pointColorMapper: (ChartData data, _) => data.color,
//           //               radius: '90%',
//           //               innerRadius: '70%',
//           //             )
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           const SizedBox(height: TSizes.sm / 2),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TripStatItem(title: 'Created Trips', count: '85'),
//               TripStatItem(title: 'Completed Trips', count: '4356'),
//               TripStatItem(title: 'Active Trips', count: '25'),
//             ],
//           ),
//           const SizedBox(height: TSizes.lg),
//
//
//           const AddTrip(),
//           Obx(() => ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: dashBoardController.allCreatedTrips.length,
//             itemBuilder: (context, index) {
//               final trip = dashBoardController.allCreatedTrips[index];
//               return TripCard(trip: trip);
//             },
//           ))
//
//
//         ],
//       ),
//     ),
//
//       ),
//     );
//   }
// }
//
//
// // class ChartData {
// //   ChartData(this.x, this.y, this.color);
// //   final String x;
// //   final double y;
// //   final Color color;
// // }
//
//  class AddTrip extends StatelessWidget {
//   const AddTrip({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Get.to(
//           const AddTripMobile(),
//           transition: Transition.rightToLeft,
//
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8FAFC), // light background
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFE2E8F0)), // light gray border
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF0272A4), Color(0xFF00B4DB)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: TSizes.spaceBtwItems),
//
//             // Text column
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Add a new Trip',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF1E293B), // Dark blue-gray
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Select the driver and assign the trip',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xff6B7280), // Lighter gray
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//

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
              // const SizedBox(height: TSizes.sm / 2),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     TripStatItem(
              //         title: dashBoardController.loggedInUser.value.userRole !=
              //                 'admin'
              //             ? 'Accepted Trips'
              //             : 'Created Trips',
              //         count: '85'),
              //     dashBoardController.loggedInUser.value.userRole != 'admin'
              //         ? const SizedBox.shrink()
              //         : const TripStatItem(title: 'Completed Trips', count: '4356'),
              //      TripStatItem(title:
              //
              //     dashBoardController.loggedInUser.value.userRole == 'admin'  ?
              //     'Active Trips' : 'Rejected Trips', count: '25'),
              //   ],
              // ),
              const SizedBox(height: TSizes.lg),

              dashBoardController.loggedInUser.value.userRole == 'admin' ?
               const AddTrip() : const SizedBox.shrink(),

              // Header Row with Refresh Icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        dashBoardController.loggedInUser.value.userRole == 'admin' ?
                        'All Trips' : 'Assigned Trips',
                        style: Theme.of(context).textTheme.titleMedium),
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
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 
                  
                  
                  dashBoardController.allCreatedTrips.length,
                  
                  
                  itemBuilder: (context, index) {
                    final trip = dashBoardController.allCreatedTrips[index];
                    return
                      dashBoardController.loggedInUser.value.userRole == 'admin' ?
                      TripCard(trip: trip) : DriverAssignedTripCard(trip: trip);
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
        Get.to(
          const AddTripMobile(),
          transition: Transition.rightToLeft,
        );
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
