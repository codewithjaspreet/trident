import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';

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

// GetX Controller for Trip Timeline

// Main Trip Timeline Screen
class TripTimelineScreen extends StatelessWidget {
  const TripTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripController());

    final args = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            _buildCustomAppBar(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Client Details Card
                    _buildClientDetailsCard(controller, args),

                    SizedBox(height: 24.h),

                    // Trip Timeline Section
                    _buildTimelineSection(controller),

                    SizedBox(height: 24.h),

                    // Complete Trip Button
                    Obx(() => controller.allStagesCompleted
                        ? _buildCompleteButton(controller)
                        : const SizedBox.shrink()),

                    SizedBox(height: 32.h),
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
      height: 80.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black87),
          ),
          SizedBox(width: 8.w),
          Text(
            'Accepted Trip',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, size: 20.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildClientDetailsCard(TripController controller, dynamic args) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Client Details',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),

          // Client Name
          _buildDetailRow('Client Name', args[2]),
          SizedBox(height: 12.h),

          // Source
          _buildDetailRow('Source', args[0]),
          SizedBox(height: 12.h),

          // Destination
          _buildDetailRow('Destination', args[1]),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection(TripController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Timeline',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => Column(
                children: List.generate(controller.stages.length, (index) {
                  return _buildTimelineStage(controller, index);
                }),
              )),
        ],
      ),
    );
  }

  Widget _buildTimelineStage(TripController controller, int index) {
    final stage = controller.stages[index];
    final isLast = index == controller.stages.length - 1;
    final canComplete = index == controller.nextIncompleteStageIndex;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stage.isCompleted
                        ? Colors.green
                        : canComplete
                            ? Colors.blue
                            : Colors.grey.shade300,
                  ),
                  child: Icon(
                    stage.isCompleted ? Icons.check : stage.icon,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.w,
                    height: 40.h,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),

            SizedBox(width: 16.w),

            // Stage content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleStageExpansion(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Text(
                            stage.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: stage.isCompleted
                                  ? Colors.green.shade700
                                  : Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          if (stage.isCompleted || canComplete)
                            Icon(
                              stage.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey.shade600,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Completed timestamp
                  if (stage.isCompleted && stage.completedAt != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'Completed: ${_formatDateTime(stage.completedAt!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  // Expandable content
                  if (stage.isExpanded && (stage.isCompleted || canComplete))
                    _buildStageExpandedContent(controller, index),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildStageExpandedContent(TripController controller, int index) {
    final stage = controller.stages[index];
    TextEditingController noteController =
        TextEditingController(text: stage.note);

    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mark as Done button (only if not completed)
          if (!stage.isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.markStageDone(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Mark as Done',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (!stage.isCompleted) SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildCompleteButton(TripController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.completeTrip,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
        child: Text(
          'Complete Trip',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
