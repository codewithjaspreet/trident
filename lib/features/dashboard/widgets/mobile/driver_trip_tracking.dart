import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                    _buildTimelineSection(controller, args),

                    SizedBox(height: 24.h),

                    // Complete Trip Button
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.tripStreamByCreatedAt(args[3]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();

                        final tripData = snapshot.data!.data();
                        if (tripData == null || tripData['stages'] == null) return const SizedBox.shrink();

                        final stages = List<Map<String, dynamic>>.from(tripData['stages']);
                        final allCompleted = stages.every((s) => s['isCompleted'] == true);

                        return allCompleted
                            ? Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: _buildCompleteButton(snapshot.data!.id),
                        )
                            : const SizedBox.shrink();
                      },
                    ),

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

  Widget _buildTimelineSection(TripController controller, dynamic args) {
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
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.tripStreamByCreatedAt(args[3]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tripData = snapshot.data!.data();
              if (tripData == null || tripData['stages'] == null) {
                return const Text('No stages found.');
              }

              final stages =
                  List<Map<String, dynamic>>.from(tripData['stages']);
              final nextIncompleteStageIndex =
                  stages.indexWhere((stage) => stage['isCompleted'] == false);

              return Column(
                children: List.generate(stages.length, (index) {
                  final stage = stages[index];
                  final canComplete = !stage['isCompleted'] &&
                      index == nextIncompleteStageIndex;
                  return _buildRealtimeTimelineStage(
                      stage, index, args, controller, canComplete);
                }),
              );
            },
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
  ) {
    final isCompleted = stage['isCompleted'] == true;
    final isLast = index == controller.stages.length - 1;

    final completedAt = stage['completedAt'] != null
        ? (stage['completedAt'] as Timestamp).toDate()
        : null;

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
                    color: isCompleted
                        ? Colors.green
                        : canComplete
                            ? Colors.blue
                            : Colors.grey.shade300,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
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
                  Text(
                    stage['name'] ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isCompleted ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                  if (completedAt != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'Completed: ${_formatDateTime(completedAt)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (!isCompleted && canComplete)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller
                            .markTripStageDoneByCreatedAt(index, args[3]),
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
                    )
                ],
              ),
            ),
          ],
        ),
        if (!isLast) SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildStageExpandedContent(
      TripController controller, int index, dynamic args) {
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
                onPressed: () =>
                    controller.markTripStageDoneByCreatedAt(index, args[3]),
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

  Widget _buildCompleteButton(String tripId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
              'status': 'Completed',
            });

            Get.snackbar(
              'Trip Completed',
              'Trip marked as completed successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade800,
              margin: EdgeInsets.all(16.w),
            );

            Get.offAllNamed(TRoutes.dashBoardScreen);
          } catch (e) {
            Get.snackbar(
              'Error',
              'Something went wrong while completing the trip.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade50,
              colorText: Colors.red.shade800,
            );
          }
        },
        icon: const Icon(Icons.check_circle_outline),
        label: Text(
          'Mark Trip Complete',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
      ),
    );
  }


  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
