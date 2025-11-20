// lib/features/analytics/views/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/trip_report_model.dart';

class TripDetailScreen extends StatelessWidget {
  final TripReport trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBanner(),
            SizedBox(height: 20.h),
            _buildDriverVehicleCard(),
            SizedBox(height: 16.h),
            _buildRouteCard(),
            SizedBox(height: 16.h),
            _buildTimelineCard(),
            SizedBox(height: 16.h),
            _buildMetricsCard(),
            SizedBox(height: 16.h),
            if (trip.remarks != null && trip.remarks!.isNotEmpty)
              _buildRemarksCard(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Trip Details',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  Widget _buildStatusBanner() {
    Color statusColor;
    String statusText = trip.tripStatus.toUpperCase();
    IconData statusIcon;

    switch (trip.tripStatus.toLowerCase()) {
      case 'completed':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'open':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.pending_rounded;
        statusText = 'OPEN';
        break;
      case 'in_review':
        statusColor = const Color(0xFF8B5CF6);
        statusIcon = Icons.rate_review_rounded;
        break;
      case 'cancelled':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info_rounded;
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              statusIcon,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Status',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (trip.inReview)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'In Review',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDriverVehicleCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Driver & Vehicle',
            Icons.person_outline_rounded,
            const Color(0xFF3B82F6),
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            Icons.person_rounded,
            'Driver Name',
            trip.driverName,
            const Color(0xFF3B82F6),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            Icons.directions_car_rounded,
            'Vehicle Number',
            trip.billedVehicle,
            const Color(0xFF3B82F6),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            Icons.local_shipping_rounded,
            'Trip Type',
            trip.tripType,
            const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Route Information',
            Icons.route_rounded,
            const Color(0xFF10B981),
          ),
          SizedBox(height: 16.h),
          _buildRouteFlow(),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey[200]),
          SizedBox(height: 16.h),
          _buildDetailRow(
            Icons.person_outline_rounded,
            'Consignor',
            trip.consignor,
            const Color(0xFF10B981),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            Icons.person_rounded,
            'Consignee',
            trip.consignee,
            const Color(0xFF10B981),
          ),
          if (trip.distance != null) ...[
            SizedBox(height: 12.h),
            _buildDetailRow(
              Icons.straighten_rounded,
              'Distance',
              '${trip.distance} km',
              const Color(0xFF10B981),
            ),
          ],

        ],
      ),
    );
  }

  Widget _buildRouteFlow() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'FROM',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    trip.source,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: const Color(0xFF10B981),
              size: 24.sp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'TO',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    trip.destination,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Timeline',
            Icons.access_time_rounded,
            const Color(0xFFF59E0B),
          ),
          SizedBox(height: 16.h),
          _buildTimelineItem(
            'Trip Date',
            DateFormat('EEEE, dd MMMM yyyy').format(trip.tripDate),
            Icons.event_rounded,
            true,
          ),
          _buildTimelineItem(
            'Created',
            DateFormat('dd MMM yyyy, HH:mm').format(trip.createdAt),
            Icons.add_circle_outline_rounded,
            trip.isCompleted,
          ),
          if (trip.isCompleted)
            _buildTimelineItem(
              'Completed',
              'Trip completed successfully',
              Icons.check_circle_rounded,
              false,
              isLast: true,
            ),
          if (trip.isCompleted) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: const Color(0xFF10B981),
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'This trip was completed on time',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      String label,
      String value,
      IconData icon,
      bool showLine, {
        bool isLast = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFF59E0B),
                size: 18.sp,
              ),
            ),
            if (showLine && !isLast)
              Container(
                width: 2.w,
                height: 40.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                color: Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Trip Metrics',
            Icons.bar_chart_rounded,
            const Color(0xFF8B5CF6),
          ),
          SizedBox(height: 16.h),

        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Remarks',
            Icons.notes_rounded,
            const Color(0xFF6B7280),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              trip.remarks!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}