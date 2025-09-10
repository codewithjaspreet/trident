import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:trident/features/auth/views/login/login.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/dashboard/views/navigation_bar.dart';
import 'package:trident/routes/routes.dart';

import '../features/auth/views/login/otp.dart';
import '../features/auth/views/splashscreen.dart';
import '../features/dashboard/views/dashboard.dart';
import '../features/trips/views/add_trip.dart';
import '../main.dart';

class TAppRoutes {

  static List<GetPage> allRoutes = [

    GetPage(
      name: TRoutes.dashBoardScreen,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashBoardController());
      }),
    ),

    GetPage(
      name: TRoutes.loginScreen,
      page: () => const TLoginScreen(),
    ),
    GetPage(
      name: TRoutes.addTripsScreen,
      page: () => const TAddTrip(),
    ),

    GetPage(
      name: TRoutes.otpScreen,
      page: () =>  OtpScreen(),
    ),

    GetPage(
      name: TRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),


    GetPage(
      name: TRoutes.navigationBar,
      page: () =>  TridentNavigationBar(),
    ),




  ];
}