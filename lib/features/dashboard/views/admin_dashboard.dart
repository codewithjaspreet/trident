import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trident/features/auth/controllers/auth_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../trips/controllers/trip_controller.dart';
import '../controllers/dashboard_controller.dart';
import 'navigation_bar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.put(DashBoardController());
    final AuthController authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(controller, authController),
              SizedBox(height: 20.h),
              _buildAnalyticsSection(controller),
              SizedBox(height: 24.h),
              _buildQuickActionsGrid(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(
      DashBoardController controller, AuthController authController) {
    return Obx(() {
      final userRole =
          controller.loggedInUser.value.userRole?.toLowerCase() ?? 'user';

      String getDashboardTitle(String role) {
        switch (role) {
          case 'admin':
            return 'Admin Dashboard';
          case 'trip manager':
          case 'tripmanager':
            return 'Trip Manager Dashboard';
          case 'driver':
            return 'Driver Dashboard';
          default:
            return 'Dashboard';
        }
      }

      IconData getDashboardIcon(String role) {
        switch (role) {
          case 'admin':
            return Icons.admin_panel_settings_rounded;
          case 'trip manager':
          case 'tripmanager':
            return Icons.manage_accounts_rounded;
          case 'driver':
            return Icons.local_shipping_rounded;
          default:
            return Icons.dashboard_rounded;
        }
      }

      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, (1 - value) * -30),
            child: Opacity(
              opacity: value,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.bgPrimary,
                      TColors.accent.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.bgPrimary.withOpacity(0.25),
                      blurRadius: 12.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: TColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        getDashboardIcon(userRole),
                        color: TColors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDashboardTitle(userRole),
                            style: TextStyle(
                              color: TColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'User: ${controller.loggedInUser.value.userMobileNumber}',
                            style: TextStyle(
                              color: TColors.white.withOpacity(0.85),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        authController.logout();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: TColors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: TColors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAnalyticsSection(DashBoardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Text(
                'Analytics Overview',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: TColors.textPrimary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final userRole =
              controller.loggedInUser.value.userRole?.toLowerCase() ?? 'user';
          return _buildRoleBasedAnalytics(controller, userRole);
        }),
      ],
    );
  }

  Widget _buildRoleBasedAnalytics(DashBoardController controller, String role) {
    final TripController tripController = Get.put(TripController());

    switch (role) {
      case 'admin':
      case 'trip manager':
      case 'tripmanager':
        // Both admin and trip manager get the same analytics
        return _buildAdminAnalytics(controller, tripController);
      case 'driver':
        return _buildDriverAnalytics(controller, tripController);
      default:
        return _buildDefaultAnalytics(controller, tripController);
    }
  }

  Widget _buildAdminAnalytics(
      DashBoardController controller, TripController tripController) {
    final totalTrips = controller.allCreatedTrips.length;
    final totalVehicles = tripController.allVehicles.length;
    final totalDrivers = tripController.allDrivers.length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.35,
      children: [
        _buildAnimatedAnalyticsCard(
          'Total Trips',
          totalTrips.toString(),
          '+${totalTrips.toInt()}',
          Icons.route_rounded,
          TColors.success,
          0,
        ),
        _buildAnimatedAnalyticsCard(
          'Total Drivers',
          totalDrivers.toString(),
          '',
          Icons.person_rounded,
          TColors.info,
          1,
        ),
        _buildAnimatedAnalyticsCard(
          'Total Vehicles',
          totalVehicles.toString(),
          '',
          Icons.local_shipping_rounded,
          TColors.bgPrimary,
          2,
        ),
        _buildAnimatedAnalyticsCard(
          'Pending Reviews',
          controller.allReviewTrips.length.toString(),
          '',
          Icons.pending_actions_rounded,
          TColors.warning,
          3,
        ),
      ],
    );
  }

  Widget _buildDriverAnalytics(
      DashBoardController controller, TripController tripController) {
    // All trips assigned to this driver (adjust filtering if needed)
    final myTrips = controller.allCreatedTrips;

    // Completed trips
    final completedTrips =
        myTrips.where((trip) => trip.status == 'Completed').toList();

    // Pending trips
    final pendingTrips =
        myTrips.where((trip) => trip.status == 'Open').toList();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.35,
      children: [
        _buildAnimatedAnalyticsCard(
          'My Trips',
          myTrips.length.toString(),
          '',
          Icons.route_rounded,
          TColors.success,
          0,
        ),
        _buildAnimatedAnalyticsCard(
          'Completed Today',
          completedTrips.length.toString(),
          '',
          Icons.check_circle_rounded,
          TColors.info,
          1,
        ),
        _buildAnimatedAnalyticsCard(
          'Pending Trips',
          pendingTrips.length.toString(),
          '',
          Icons.pending_rounded,
          TColors.warning,
          2,
        ),
      ],
    );
  }

  Widget _buildDefaultAnalytics(
      DashBoardController controller, TripController tripController) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.35,
      children: [
        _buildAnimatedAnalyticsCard(
          'Total Trips',
          controller.allCreatedTrips.length.toString(),
          '',
          Icons.route_rounded,
          TColors.success,
          0,
        ),
      ],
    );
  }

  Widget _buildAnimatedAnalyticsCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: () {
                print('Tapped on $title');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.grey.withOpacity(0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TweenAnimationBuilder<int>(
                      duration: Duration(milliseconds: 1200 + (index * 100)),
                      tween: IntTween(
                        begin: 0,
                        end: int.tryParse(
                                value.replaceAll(RegExp(r'[^\d]'), '')) ??
                            0,
                      ),
                      builder: (context, animatedValue, child) {
                        String displayValue = value.contains('%')
                            ? '$animatedValue%'
                            : value.contains('₹')
                                ? '₹${animatedValue}L'
                                : animatedValue.toString();

                        return Text(
                          displayValue,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: TColors.textPrimary,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: TColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsGrid(DashBoardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: TColors.textPrimary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final userRole =
              controller.loggedInUser.value.userRole?.toLowerCase() ?? 'user';
          return _buildRoleBasedQuickActions(userRole);
        }),
      ],
    );
  }

  Widget _buildRoleBasedQuickActions(String role) {
    switch (role) {
      case 'admin':
      case 'trip manager':
      case 'tripmanager':
        // Both admin and trip manager get the same quick actions
        return _buildAdminQuickActions();
      case 'driver':
        return _buildDriverQuickActions();
      default:
        return _buildDefaultQuickActions();
    }
  }

  Widget _buildAdminQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.15,
      children: [
        _buildAnimatedActionCard(
          'Trips',
          'Monitor all routes',
          Icons.route_outlined,
          TColors.warning,
          0,
        ),
        _buildAnimatedActionCard(
          'Drivers',
          'Manage profiles',
          Icons.person_outline_rounded,
          TColors.bgPrimary,
          1,
        ),
        _buildAnimatedActionCard(
          'Vehicles',
          'Track fleet',
          Icons.local_shipping_outlined,
          TColors.success,
          2,
        ),
        _buildAnimatedActionCard(
          'Analytics',
          'View reports',
          Icons.analytics_outlined,
          TColors.info,
          3,
        ),
      ],
    );
  }

  Widget _buildDriverQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.15,
      children: [
        _buildAnimatedActionCard(
          'My Trips',
          'View assigned trips',
          Icons.route_outlined,
          TColors.warning,
          0,
        ),
        _buildAnimatedActionCard(
          'Navigation',
          'Start navigation',
          Icons.navigation_outlined,
          TColors.info,
          1,
        ),
      ],
    );
  }

  Widget _buildDefaultQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.15,
      children: [
        _buildAnimatedActionCard(
          'Trips',
          'View trips',
          Icons.route_outlined,
          TColors.warning,
          0,
        ),
      ],
    );
  }

  Widget _buildAnimatedActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset((1 - animValue) * 50, 0),
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: () {
                _handleNavigation(title);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: TColors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.08),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 20.sp,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12.sp,
                          color: TColors.iconPrimary,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: TColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(String title) {
    final NavigationController navController = Get.find<NavigationController>();

    switch (title.toLowerCase()) {
      case 'drivers':
        navController.navigateToDrivers();
        print('Navigate to Drivers');
        break;
      case 'vehicles':
        navController.navigateToVehicles();
        print('Navigate to Vehicles');
        break;
      case 'trips':
      case 'my trips':
        navController.navigateToAllTrips();
        print('Navigate to Trips');
        break;
      case 'analytics':
        navController.navigateToAnalytics();
        break;
      case 'reviews':
        print('Navigate to Reviews');
        break;
      case 'routes':
        print('Navigate to Routes');
        break;
      case 'navigation':
        print('Start Navigation');
        break;
    }
  }
}
