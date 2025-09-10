import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/features/dashboard/views/navigation_bar.dart';
import 'package:trident/features/dashboard/widgets/mobile/trip_manager_review_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../trips/controllers/trip_controller.dart';
import '../../controllers/dashboard_controller.dart';

class ReviewTripsSection extends StatelessWidget {
  const ReviewTripsSection({super.key, required this.dashboardController, required this.navigationController});

  final DashBoardController dashboardController;
  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(TSizes.lg.w, 40.h, TSizes.lg.w, TSizes.lg.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFFA855F7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: TSizes.md.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Reviews'.tr,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Manage and approve trip requests'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stats Badge
                      Obx(() {
                        final reviewCount = dashboardController.allReviewTrips.length;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: reviewCount > 0
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '$reviewCount',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: TSizes.lg.h),
                  // Quick Action Chips
                  Row(
                    children: [
                      _buildQuickActionChip(
                        icon: Icons.refresh_outlined,
                        label: 'Refresh'.tr,
                        onTap: () => dashboardController.getAllReviewingTrips(),
                      ),
                      SizedBox(width: TSizes.sm.w),
                      _buildQuickActionChip(
                        icon: Icons.filter_list_outlined,
                        label: 'Filter'.tr,
                        onTap: () => _showFilterOptions(context),
                      ),
                      SizedBox(width: TSizes.sm.w),
                      _buildQuickActionChip(
                        icon: Icons.sort_outlined,
                        label: 'Sort'.tr,
                        onTap: () => _showSortOptions(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Obx(() {
              if (dashboardController.isLoading.value) {
                return _buildLoadingState();
              }

              if (dashboardController.allReviewTrips.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => dashboardController.getAllReviewingTrips(),
                color: const Color(0xFF6366F1),
                backgroundColor: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    top: TSizes.md.h,
                    bottom: TSizes.xl.h,
                  ),
                  itemCount: dashboardController.allReviewTrips.length,
                  itemBuilder: (context, index) {
                    final trip = dashboardController.allReviewTrips[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutBack,
                      child: TripManagerReviewCard(trip: trip),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.w, color: Colors.white),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: TSizes.md.h),
                Text(
                  'Loading review trips...'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 48.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: TSizes.lg.h),
                Text(
                  'All Caught Up!'.tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: TSizes.sm.h),
                Text(
                  'No trips are currently pending review.\nGreat job staying on top of things!'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: TSizes.lg.h),
                ElevatedButton.icon(
                  onPressed: () => Get.find<DashBoardController>().getAllReviewingTrips(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.refresh, size: 16.w),
                  label: Text(
                    'Refresh'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(TSizes.lg.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: TSizes.lg.h),
            Text(
              'Filter Options'.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: TSizes.md.h),
            // Add filter options here
            Text(
              'Filter functionality coming soon...'.tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + TSizes.lg.h),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(TSizes.lg.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: TSizes.lg.h),
            Text(
              'Sort Options'.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: TSizes.md.h),
            // Add sort options here
            Text(
              'Sort functionality coming soon...'.tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + TSizes.lg.h),
          ],
        ),
      ),
    );
  }
}