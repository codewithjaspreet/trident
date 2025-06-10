import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:trident/features/auth/views/login/login.dart';
import 'package:trident/routes/routes.dart';

import '../features/dashboard/views/dashboard.dart';
import '../features/dashboard/widgets/mobile/dashboard_mobile_layout.dart';
import '../features/trips/views/add_trip.dart';
import '../main.dart';

class TAppRoutes {

  static List<GetPage> allRoutes = [

    GetPage(
      name: TRoutes.dashBoardScreen,
      page: () => const DashboardScreen(),
    ),

    GetPage(
      name: TRoutes.loginScreen,
      page: () => const TLoginScreen(),
    ),
    GetPage(
      name: TRoutes.addTripsScreen,
      page: () => const TAddTrip(),
    ),


  ];
}