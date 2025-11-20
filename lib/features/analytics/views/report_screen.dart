// lib/features/analytics/views/report_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/report_controller.dart';
import 'daily_report_screen.dart';
import 'weekly_report_screen.dart';
import 'monthly_report_screen.dart';
import 'vehicles_report_screen.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCard(),
              SizedBox(height: 20.h),
              _buildReportsList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
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
                child: Icon(Icons.analytics_outlined,
                    color: const Color(0xFF2563EB), size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Text('Overview',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B))),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildStat('Total', controller.totalTrips.toString())),
              SizedBox(width: 12.w),
              Expanded(child: _buildStat('Completed', controller.completedTrips.toString())),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildStat('Pending', controller.pendingTrips.toString())),
              SizedBox(width: 12.w),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB))),
          SizedBox(height: 4.h),
          Text(label,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    final reports = [
      {'title': 'Daily Report', 'icon': Icons.today, 'screen': DailyReportScreen()},
      {'title': 'Weekly Report', 'icon': Icons.calendar_view_week, 'screen': WeeklyReportScreen()},
      {'title': 'Monthly Report', 'icon': Icons.calendar_month, 'screen': MonthlyReportScreen()},
      {'title': 'Vehicle Usage', 'icon': Icons.directions_car, 'screen': VehiclesReportScreen()},
    ];

    return Column(
      children: reports
          .map((r) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(r['icon'] as IconData,
                color: const Color(0xFF2563EB), size: 22.sp),
          ),
          title: Text(r['title'] as String,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B))),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16.sp, color: const Color(0xFF64748B)),
          onTap: () => Get.to(() => r['screen'] as Widget),
        ),
      ))
          .toList(),
    );
  }
}