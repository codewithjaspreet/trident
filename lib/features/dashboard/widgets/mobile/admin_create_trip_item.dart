import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/dashboard_controller.dart';
import 'driver_trip_tracking.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('d MMMM y \'at\' h:mm a').format(trip.createdAt!);

    return TRoundedContainer(
      onTap: (){
        final dashboardController = Get.find<DashBoardController>();
        Get.to(const TripTimelineScreen(),
            arguments: [trip.source, trip.destination, trip.billedTo,trip.createdAt,dashboardController.loggedInUser.value.userRole ]);

      },
      margin:
          EdgeInsets.symmetric(horizontal: TSizes.md.w, vertical: TSizes.sm.h),
      padding: EdgeInsets.all(TSizes.md.w),
      backgroundColor: Colors.white,
      showBorder: true,
      borderColor: const Color(0xFFE2E8F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header: Billed To & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.billedTo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            fontSize: 16.sp,
                            letterSpacing: -0.2,
                          ),
                    ),
                    // SizedBox(height: 2.h),
                    // Text(
                    //   'Trip #',
                    //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    //     color: const Color(0xFF64748B),
                    //     fontSize: 12.sp,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(width: TSizes.sm.w),
              _buildStatusBadge(),
            ],
          ),

          SizedBox(height: TSizes.md.h),

          /// Route Information with enhanced styling
          _buildRouteSection(context),

          SizedBox(height: TSizes.md.h),

          /// Trip Details Grid
          _buildDetailsGrid(context, dateFormatted),

          SizedBox(height: TSizes.sm.h),

          /// Bottom Actions or Additional Info
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isCompleted = trip.status.toLowerCase() == 'completed';
    final isPending = trip.status.toLowerCase() == 'pending';
    final isInProgress = trip.status.toLowerCase() == 'in_progress';

    Color badgeColor;
    Color textColor;
    IconData icon;

    if (isCompleted) {
      badgeColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
      icon = Icons.check_circle_outline;
    } else if (isPending) {
      badgeColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFF92400E);
      icon = Icons.schedule_outlined;
    } else if (isInProgress) {
      badgeColor = const Color(0xFFDEF7FF);
      textColor = const Color(0xFF0369A1);
      icon = Icons.directions_car_outlined;
    } else {
      badgeColor = const Color(0xFFF1F5F9);
      textColor = const Color(0xFF475569);
      icon = Icons.info_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.w,
            color: textColor,
          ),
          SizedBox(width: 4.w),
          Text(
            trip.status.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 11.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TSizes.sm.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.route,
              size: 16.w,
              color: Colors.white,
            ),
          ),
          SizedBox(width: TSizes.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: trip.source,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      TextSpan(
                        text: ' → ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      TextSpan(
                        text: trip.destination,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, String dateFormatted) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.person_outline,
                label: 'Driver',
                value: trip.driverName,
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.local_shipping_outlined,
                label: 'Vehicle',
                value: trip.billedVehicle,
                iconColor: const Color(0xFF06B6D4),
              ),
            ),
          ],
        ),
        SizedBox(height: TSizes.sm.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.calendar_today_outlined,
                label: 'Date & Time',
                value: dateFormatted,
                iconColor: const Color(0xFFEF4444),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.category_outlined,
                label: 'Type',
                value: trip.tripType,
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TSizes.sm.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.w,
                color: iconColor,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TSizes.sm.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 14.w,
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: 4.w),
              Text(
                'Updated ${_getTimeAgo()}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // InkWell(
          //   onTap: () {
          //     // Handle tap action
          //   },
          //   borderRadius: BorderRadius.circular(6.r),
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 8.w,
          //       vertical: 4.h,
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           'View Details',
          //           style: TextStyle(
          //             fontSize: 11.sp,
          //             color: const Color(0xFF3B82F6),
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         SizedBox(width: 2.w),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 10.w,
          //           color: const Color(0xFF3B82F6),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(trip.createdAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
