import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/trips/views/all_trips.dart';
import 'package:trident/features/trips/widgets/add_trip_mobile.dart';
import 'package:trident/utils/constants/colors.dart';

import '../../../utils/coming_soon.dart';
import 'admin_dashboard.dart';

class TridentNavigationBar extends StatelessWidget {
  TridentNavigationBar({super.key});

  final NavigationController navigationController =
      Get.put(NavigationController());
  final DashBoardController dashBoardController =
      Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return PersistentTabView(
          context,
          controller: controller.persistentTabController,
          screens: _buildScreens(),
          items: _buildNavBarItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          padding: const EdgeInsets.only(top: 8),
          backgroundColor: Colors.white,
          isVisible: true,
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              duration: Duration(milliseconds: 300),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight + 10,
          navBarStyle: NavBarStyle.style12,
          onItemSelected: (index) {
            controller.changeIndex(index);
          },
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    final userRole = GetStorage().read('user_role') ?? 'driver';

    if (userRole == 'admin') {
      return [
        // First tab: Admin Dashboard with nested navigation
        Navigator(
          key: navigationController.adminNavigatorKey,
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/':
                page = const AdminDashboard();
                break;
              case '/allTrips':
                page = Scaffold(
                  appBar: AppBar(
                    title: const Text('All Trips'),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        child: SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                  color: Colors.grey[400]!, width: 1.5),
                              backgroundColor: Colors.grey[100],
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Get.to(const AddTripMobile());
                            },
                            child: const Icon(Icons.add,
                                size: 22, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        navigationController.adminNavigatorKey.currentState
                            ?.pop();
                      },
                    ),
                  ),
                  body: const AllTripsSection(),
                );
                break;
              default:
                page = const AdminDashboard();
            }
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            );
          },
        ),
        // Second tab: Coming Soon Page for Admin Analytics
        const ComingSoonPage(),
      ];
    } else {
      // For drivers and other roles - FIXED: Add nested navigation for all roles
      return [
        // First tab: Dashboard with nested navigation for trips
        Navigator(
          key: navigationController
              .driverNavigatorKey, // Use driver navigator key
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/':
                page = const AdminDashboard(); // This now handles all roles
                break;
              case '/allTrips':
                page = _buildTripsPageForRole(userRole);
                break;
              default:
                page = const AdminDashboard();
            }
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            );
          },
        ),
        // Second tab: Coming Soon Page for role-specific feature
        const ComingSoonPage(),
      ];
    }
  }

  Widget _buildTripsPageForRole(String userRole) {
    String appBarTitle;
    bool showAddButton = false;

    switch (userRole) {
      case 'admin':
        appBarTitle = 'All Trips';
        showAddButton = true; // Only admin can add trips
        break;
      case 'driver':
        appBarTitle = 'My Trips';
        showAddButton = false; // Driver cannot add trips
        break;
      case 'Trip Manager':
        appBarTitle = 'Managed Trips';
        showAddButton = true; // Trip manager cannot add trips
        break;
      default:
        appBarTitle = 'All Trips';
        showAddButton = false; // Default: no add button
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: showAddButton
            ? [
                Container(
                  margin: EdgeInsets.only(right: 12.w),
                  child: SizedBox(
                    width: 25.w,
                    height: 25.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                        backgroundColor: Colors.grey[100],
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Get.to(const AddTripMobile());
                      },
                      child: const Icon(Icons.add,
                          size: 22, color: Colors.black87),
                    ),
                  ),
                ),
              ]
            : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            navigationController.getCurrentNavigatorKey()?.currentState?.pop();
          },
        ),
      ),
      body: const AllTripsSection(),
    );
  }

  List<PersistentBottomNavBarItem> _buildNavBarItems() {
    final userRole = GetStorage().read('user_role') ?? 'driver';

    if (userRole == 'admin') {
      return [
        _buildNavBarItem(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          title: 'Dashboard',
          activeColor: TColors.bgPrimary,
          inactiveColor: Colors.grey[500]!,
        ),
        _buildNavBarItem(
          icon: Icons.analytics_outlined,
          activeIcon: Icons.analytics,
          title: 'Analytics',
          activeColor: TColors.bgPrimary,
          inactiveColor: Colors.grey[500]!,
        ),
      ];
    } else {
      return [
        _buildNavBarItem(
          icon: Icons.local_shipping_outlined,
          activeIcon: Icons.local_shipping,
          title: userRole == 'driver' ? 'My Trips' : 'All Trips',
          activeColor: const Color(0xff515DEF),
          inactiveColor: Colors.grey[600]!,
        ),
        _buildNavBarItem(
          icon: Icons.upcoming_outlined,
          activeIcon: Icons.upcoming,
          title: userRole == 'driver' ? 'Upcoming' : 'Insights',
          activeColor: const Color(0xff515DEF),
          inactiveColor: Colors.grey[600]!,
        ),
      ];
    }
  }

  PersistentBottomNavBarItem _buildNavBarItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(activeIcon),
      inactiveIcon: Icon(icon),
      title: title,
      activeColorPrimary: activeColor,
      inactiveColorPrimary: inactiveColor,
      activeColorSecondary: TColors.primary,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      iconSize: 24,
    );
  }
}

class NavigationController extends GetxController {
  late PersistentTabController persistentTabController;
  var currentIndex = 0.obs;
  final DashBoardController dashBoardController =
      Get.put(DashBoardController());
  final GetStorage _storage = GetStorage();

  // Navigator keys for nested navigation
  final GlobalKey<NavigatorState> adminNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> driverNavigatorKey =
      GlobalKey<NavigatorState>(); // Added driver navigator key
  final GlobalKey<NavigatorState> tripManagerNavigatorKey =
      GlobalKey<NavigatorState>(); // Added trip manager navigator key

  @override
  void onInit() {
    super.onInit();
    persistentTabController = PersistentTabController(initialIndex: 0);
    _initializeForUserRole();
  }

  @override
  void onClose() {
    persistentTabController.dispose();
    super.onClose();
  }

  void _initializeForUserRole() {
    final userRole = _storage.read('user_role') ?? 'driver';

    if (userRole == 'admin') {
      dashBoardController.getAllCreatedTrips();
    } else if (userRole == 'driver') {
      dashBoardController.getAllDriverAssignedTrips();
    } else {
      dashBoardController.getAllCreatedTrips();
    }
  }

  // Helper method to get the current navigator key based on user role
  GlobalKey<NavigatorState>? getCurrentNavigatorKey() {
    final userRole = _storage.read('user_role') ?? 'driver';

    switch (userRole) {
      case 'admin':
        return adminNavigatorKey;
      case 'driver':
        return driverNavigatorKey;
      case 'trip manager':
      case 'tripmanager':
        return tripManagerNavigatorKey;
      default:
        return driverNavigatorKey;
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    final userRole = _storage.read('user_role') ?? 'driver';

    _handleNavigationLogic(index, userRole);
    update();
  }

  void _handleNavigationLogic(int index, String userRole) {
    switch (userRole) {
      case 'admin':
        _handleAdminNavigation(index);
        break;
      case 'driver':
        _handleDriverNavigation(index);
        break;
      default:
        _handleTripManagerNavigation(index);
        break;
    }
  }

  void _handleAdminNavigation(int index) {
    switch (index) {
      case 0:
        // Reset to dashboard if navigated away
        if (adminNavigatorKey.currentState?.canPop() == true) {
          adminNavigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
        break;
      case 1:
        // Second tab is now Coming Soon page, no additional logic needed
        break;
    }
  }

  void _handleDriverNavigation(int index) {
    switch (index) {
      case 0:
        // Reset to dashboard if navigated away
        if (driverNavigatorKey.currentState?.canPop() == true) {
          driverNavigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
        dashBoardController.getAllDriverAssignedTrips();
        break;
      case 1:
        // Second tab is now Coming Soon page, no additional logic needed
        break;
    }
  }

  void _handleTripManagerNavigation(int index) {
    switch (index) {
      case 0:
        // Reset to dashboard if navigated away
        if (tripManagerNavigatorKey.currentState?.canPop() == true) {
          tripManagerNavigatorKey.currentState
              ?.popUntil((route) => route.isFirst);
        }
        dashBoardController.getAllCreatedTrips();
        break;
      case 1:
        // Second tab is now Coming Soon page, no additional logic needed
        break;
    }
  }

  // Updated method to navigate to All Trips from Dashboard (works for all roles)
  void navigateToAllTrips() {
    if (currentIndex.value == 0) {
      final userRole = _storage.read('user_role') ?? 'driver';
      final navigatorKey = getCurrentNavigatorKey();

      if (navigatorKey != null) {
        navigatorKey.currentState?.pushNamed('/allTrips');
      }
    }
  }

  void navigateToTab(int index) {
    persistentTabController.jumpToTab(index);
    changeIndex(index);
  }

  void refreshCurrentTab() {
    final userRole = _storage.read('user_role') ?? 'driver';
    _handleNavigationLogic(currentIndex.value, userRole);
  }
}
