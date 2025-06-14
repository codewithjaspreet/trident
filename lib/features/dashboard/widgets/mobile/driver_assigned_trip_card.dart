import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../utils/constants/sizes.dart';

class DriverAssignedTripCard extends StatelessWidget {
  final TripModel trip;

  const DriverAssignedTripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd MMM yyyy').format(trip.tripDate);

    return TRoundedContainer(
      margin: EdgeInsets.symmetric(horizontal: TSizes.md.w, vertical: TSizes.sm.h),
      padding: EdgeInsets.all(TSizes.md.w),
      backgroundColor: Colors.white,
      showBorder: true,
      borderColor: const Color(0xFFE2E8F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Route Section
          Row(
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
                child: RichText(
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
              ),
            ],
          ),

          SizedBox(height: TSizes.md.h),

          /// Client Info
          Row(
            children: [
              Icon(Icons.business_outlined, size: 16.w, color: const Color(0xFF06B6D4)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  trip.billedTo,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: TSizes.sm.h),

          /// Date
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16.w, color: const Color(0xFFEF4444)),
              SizedBox(width: 6.w),
              Text(
                dateFormatted,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),

          SizedBox(height: TSizes.sm.h),

          /// Optional Status Badge (if needed)
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = trip.status.toLowerCase();
    Color badgeColor;
    Color textColor;
    String label;

    switch (status) {
      case 'loading':
        badgeColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'Loading';
        break;
      case 'loaded':
        badgeColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
        label = 'Loaded';
        break;
      case 'dispatched':
        badgeColor = const Color(0xFFDEF7FF);
        textColor = const Color(0xFF0369A1);
        label = 'Dispatched';
        break;
      default:
        badgeColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
        label = trip.status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
