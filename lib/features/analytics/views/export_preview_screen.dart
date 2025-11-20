// lib/features/analytics/views/export_preview_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/report_controller.dart';

class ExportPreviewScreen extends StatelessWidget {
  ExportPreviewScreen({super.key});

  final controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Export Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_download, size: 64.sp, color: const Color(0xFF2563EB)),
              SizedBox(height: 24.h),
              Text('Export Complete',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B))),
              SizedBox(height: 8.h),
              Text('Your file has been shared',
                  style: TextStyle(fontSize: 15.sp, color: const Color(0xFF64748B))),
            ],
          ),
        ),
      ),
    );
  }
}