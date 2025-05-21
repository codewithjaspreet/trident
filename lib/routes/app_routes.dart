import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:trident/routes/routes.dart';

import '../main.dart';

class TAppRoutes {

  static List<GetPage> allRoutes = [

    GetPage(
      name: TRoutes.responsiveDesignTut,
      page: () => const ResponsiveDesignTutorialScreen(),
    ),

  ];
}