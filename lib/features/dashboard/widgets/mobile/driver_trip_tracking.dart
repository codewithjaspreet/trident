
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:trident/routes/routes.dart';


// Trip Stage Model
class TripStage {
  final String name;
  final IconData icon;
  bool isCompleted;
  DateTime? completedAt;
  String note;
  bool isExpanded;

  TripStage({
    required this.name,
    required this.icon,
    this.isCompleted = false,
    this.completedAt,
    this.note = '',
    this.isExpanded = false,
  });
}

class TripTimelineScreen extends StatelessWidget {
  const TripTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripController());
    final args = Get.arguments;
    final userRole = args.length > 4 ? args[4] : 'driver';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildClientDetailsCard(controller, args),
                    SizedBox(height: 24.h),
                    _buildTimelineSection(controller, args, userRole),
                    SizedBox(height: 24.h),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.tripStreamByCreatedAt(args[3]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final tripData = snapshot.data!.data();
                        if (tripData == null || tripData['stages'] == null) return const SizedBox.shrink();
                        final stages = List<Map<String, dynamic>>.from(tripData['stages']);
                        final allCompleted = stages.every((s) => s['is_completed'] == true);

                        return allCompleted && tripData['trip_status'] != 'Completed' && userRole == 'driver'
                            ? Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: _buildCompleteButton(snapshot.data!.id),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: Colors.white),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trip Details'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Track your journey progress'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(Icons.person_outline, size: 22.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildClientDetailsCard(TripController controller, dynamic args) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background pattern
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF667EEA).withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.person_outline, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Client Information'.tr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildDetailRow('Client Name'.tr, args[2], Icons.account_circle_outlined),
                SizedBox(height: 20.h),
                _buildDetailRow('Pickup Location'.tr, args[0], Icons.location_on_outlined),
                SizedBox(height: 20.h),
                _buildDetailRow('Drop-off Location'.tr, args[1], Icons.flag_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: const Color(0xFF667EEA), size: 16.sp),
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
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(TripController controller, dynamic args, String userRole) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background pattern
          Positioned(
            bottom: -30.h,
            left: -30.w,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.timeline, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Trip Timeline'.tr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.tripStreamByCreatedAt(args[3]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                          ),
                        ),
                      );
                    }
                    final tripData = snapshot.data!.data();
                    if (tripData == null || tripData['stages'] == null) {
                      return Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: const Color(0xFFF59E0B), size: 20.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'No stages found.'.tr,
                              style: TextStyle(
                                color: const Color(0xFF92400E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final stages = List<Map<String, dynamic>>.from(tripData['stages']);
                    final nextIncompleteStageIndex = stages.indexWhere((stage) => stage['is_completed'] == false);

                    return Column(
                      children: List.generate(stages.length, (index) {
                        final stage = stages[index];
                        final canComplete = !stage['is_completed'] && index == nextIncompleteStageIndex;
                        return _buildRealtimeTimelineStage(stage, index, args, controller, canComplete, userRole);
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeTimelineStage(
      Map<String, dynamic> stage,
      int index,
      dynamic args,
      TripController controller,
      bool canComplete,
      String userRole,
      ) {
    final isCompleted = stage['is_completed'] == true;
    final isLast = index == controller.stages.length - 1;
    final completedAt = stage['completed_at'] != null
        ? (stage['completed_at'] as Timestamp).toDate().toLocal()
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator column
            SizedBox(
              width: 44.w,
              child: Column(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isCompleted
                          ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                          : canComplete
                          ? const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)])
                          : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400]),
                      boxShadow: [
                        if (isCompleted || canComplete)
                          BoxShadow(
                            color: (isCompleted ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withOpacity(0.3),
                            blurRadius: 12.r,
                            offset: Offset(0, 4.h),
                          ),
                      ],
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_rounded : canComplete ? Icons.radio_button_unchecked : Icons.circle,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3.w,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isCompleted ? const Color(0xFF10B981) : Colors.grey.shade300,
                              Colors.grey.shade200,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Content section - flexible to prevent overflow
            Flexible(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFF0FDF4)
                      : canComplete
                      ? const Color(0xFFEFF6FF)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.2)
                        : canComplete
                        ? const Color(0xFF3B82F6).withOpacity(0.2)
                        : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stage name and status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            stage['name'].toString().tr ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: isCompleted
                                  ? const Color(0xFF065F46)
                                  : canComplete
                                  ? const Color(0xFF1E40AF)
                                  : const Color(0xFF64748B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCompleted) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Done'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Completion time
                    if (completedAt != null) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.access_time, color: const Color(0xFF059669), size: 12.sp),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                maxLines: 2,
                                _formatDateTime(completedAt),
                                style: TextStyle(

                                  fontSize: 10.sp,
                                  color: const Color(0xFF059669),
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Action button for driver
                    if (!isCompleted && canComplete && userRole == 'driver') ...[
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 12.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.markTripStageDoneByCreatedAt(index, args[3]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline, size: 16.sp),
                              SizedBox(width: 6.w),
                              Text(
                                'Mark as Done'.tr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Admin status
                    if (!isCompleted && userRole == 'admin') ...[
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Awaiting Completion'.tr,
                              style: TextStyle(
                                color: const Color(0xFF92400E),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton(String tripId) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.4),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await FirebaseFirestore.instance.collection('trips').doc(tripId).update({ 'trip_status': 'Completed' });
            Get.snackbar(
              'Trip Completed'.tr,
              'Trip marked as completed successfully!'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFF0FDF4),
              colorText: const Color(0xFF059669),
              margin: EdgeInsets.all(16.w),
              borderRadius: 12.r,
              icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
            );
            Get.offAllNamed(TRoutes.dashBoardScreen);
          } catch (e) {
            Get.snackbar(
              'Error'.tr,
              'Something went wrong while completing the trip.'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFFEF2F2),
              colorText: const Color(0xFFDC2626),
              margin: EdgeInsets.all(16.w),
              borderRadius: 12.r,
              icon: const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
            );
          }
        },
        icon: Icon(Icons.flag_rounded, size: 22.sp),
        label: Text(
          'Complete Trip'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    return '${DateFormat('d MMMM').format(localTime)} at ${DateFormat('h:mm a').format(localTime)}';
  }


}