import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/features/dashboard/widgets/mobile/trip_edit_screen.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../trips/controllers/trip_controller.dart';

class TripManagerReviewCard extends StatelessWidget {
  final TripModel trip;

  const TripManagerReviewCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('d MMMM y \'at\' h:mm a').format(trip.createdAt!);

    return TRoundedContainer(
      onTap: () {
        // Navigate to detailed review screen
        // Get.to(const TripReviewDetailScreen(), arguments: [trip]);
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
          /// Header with Priority Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 16.w,
                          color: const Color(0xFF3B82F6),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Trip Review Required'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${trip.billedTo} - ${trip.tripType}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            fontSize: 16.sp,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: TSizes.sm.w),
              Column(
                children: [
                  _buildStatusBadge(),
                  SizedBox(height: 4.h),
                  _buildPriorityBadge(),
                ],
              ),
            ],
          ),

          SizedBox(height: TSizes.md.h),

          _buildRouteSection(context),
          SizedBox(height: TSizes.md.h),
          _buildDetailsGrid(context, dateFormatted),
          SizedBox(height: TSizes.md.h),
          _buildActionButtons(context),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: textColor),
          SizedBox(width: 3.w),
          Text(
            trip.status.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 10.sp,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    // Assuming priority is determined by trip urgency or type
    final isHighPriority = trip.tripType.toLowerCase() == 'emergency' ||
        trip.tripType.toLowerCase() == 'urgent';

    if (!isHighPriority) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high, size: 10.w, color: const Color(0xFFEF4444)),
          SizedBox(width: 2.w),
          Text(
            'HIGH',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
              fontSize: 9.sp,
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
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.route, size: 16.w, color: Colors.white),
          ),
          SizedBox(width: TSizes.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route for Review'.tr,
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
          Icon(
            Icons.visibility_outlined,
            size: 16.w,
            color: const Color(0xFF64748B),
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
                label: 'Driver'.tr,
                value: trip.driverName,
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.local_shipping_outlined,
                label: 'Vehicle'.tr,
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
                icon: Icons.schedule_outlined,
                label: 'Created At'.tr,
                value: dateFormatted,
                iconColor: const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.business_outlined,
                label: 'Consignor'.tr,
                value: trip.consignor ?? 'N/A',
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
      padding: EdgeInsets.symmetric(horizontal: TSizes.sm.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.w, color: iconColor),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [

        SizedBox(width: TSizes.sm.w),
        Expanded(
          child: _buildActionButton(
            onTap: () => _handleEditTrip(),
            icon: Icons.edit_outlined,
            label: 'Edit'.tr,
            backgroundColor: const Color(0xFFFEF3C7),
            textColor: const Color(0xFF92400E),
            borderColor: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16.w, color: textColor),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditTrip() async {
    // Get the existing TripController or create one if it doesn't exist

    final result = await Get.to(() => TripEditScreen(trip: trip));

    // If result is true, it means the trip was updated successfully
    if (result == true) {
      // You can refresh the parent list here if needed
      // This would typically be handled by the parent widget
      Get.snackbar(
        'Success',
        'Trip updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showApproveDropdown(TripController controller, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 8,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with accent line
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF16A34A).withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: const Color(0xFF16A34A),
                              size: 20.w,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Approve Trip',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Confirm trip approval',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This will permanently approve the trip request. The traveler will be notified immediately.',
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.approveTrip();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ).copyWith(
                                overlayColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16.w,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Approve Trip',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
