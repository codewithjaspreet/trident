import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/routes/routes.dart';

class RoutesObserver extends GetObserver{


  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {

    final sideBarController = Get.put(SideBarController());

    if (previousRoute!= null) {

      for(var routeName in TRoutes.sideBarMenuItems){
        if(previousRoute.settings.name == routeName){
          sideBarController.activeItem.value = routeName;
        }
      }
    }
  }
}