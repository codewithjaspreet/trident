// lib/features/analytics/views/driver_report_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/report_controller.dart';

class DriverReportScreen extends StatelessWidget {
  DriverReportScreen({super.key});

  final controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final drivers = controller.getTopDrivers();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Top Drivers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: drivers.isEmpty
          ? _buildEmpty()
          : ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: drivers.length,
        itemBuilder: (context, index) => _buildDriverCard(drivers[index], index + 1),
      ),
    );
  }

  Widget _buildDriverCard(driver, int rank) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:  Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text('#$rank',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB))),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driver.name,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B))),
                Text('${driver.totalTrips} trips • ${driver.completedTrips} completed',
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text('${driver.completionRate}%',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB))),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64.sp, color: const Color(0xFFE2E8F0)),
          SizedBox(height: 16.h),
          Text('No driver data',
              style: TextStyle(fontSize: 17.sp, color: const Color(0xFF64748B))),
        ],
      ),
    );
  }
}