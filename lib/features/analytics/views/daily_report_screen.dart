// lib/features/analytics/views/daily_report_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controllers/report_controller.dart';
import '../models/trip_report_model.dart';

class DailyReportScreen extends StatelessWidget {
  DailyReportScreen({super.key});

  final controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final trips = controller.getDayTrips();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Daily Report',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        actions: [
          if (trips.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.download, color: Color(0xFF2563EB)),
              onSelected: (value) {
                if (value == 'excel') {
                  controller.exportExcel(trips, 'Daily_Report');
                } else {
                  controller.exportPDF(trips, 'Daily Report');
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'excel', child: Text('Export Excel')),
                const PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
              ],
            ),
        ],
      ),
      body: trips.isEmpty
          ? _buildEmpty()
          : ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: trips.length,
        itemBuilder: (context, index) => _buildTripCard(trips[index]),
      ),
    );
  }

  Widget _buildTripCard(TripReport trip) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:  Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.local_shipping,
                    color: const Color(0xFF2563EB), size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.driverName,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B))),
                    Text(trip.billedVehicle,
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B))),
                  ],
                ),
              ),
              _buildStatusBadge(trip.tripStatus),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16.sp, color: const Color(0xFF64748B)),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(trip.route,
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1E293B))),
                ),
                Text(DateFormat('MMM dd, yyyy').format(trip.tripDate),
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status.toLowerCase() == 'completed'
        ? const Color(0xFF2563EB)
        : const Color(0xFF60A5FA);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64.sp, color: const Color(0xFFE2E8F0)),
          SizedBox(height: 16.h),
          Text('No trips today',
              style: TextStyle(fontSize: 17.sp, color: const Color(0xFF64748B))),
        ],
      ),
    );
  }
}

