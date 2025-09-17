import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:trident/routes/routes.dart';

// Add these dependencies to pubspec.yaml:
// syncfusion_flutter_datepicker: ^23.2.7
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildClientInfoCard(args),
            SizedBox(height: 24.h),
            _buildStagesSection(controller, args, userRole),
            SizedBox(height: 24.h),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.tripStreamByCreatedAt(args[3]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final tripData = snapshot.data!.data();
                if (tripData == null || tripData['stages'] == null)
                  return const SizedBox.shrink();
                final stages =
                    List<Map<String, dynamic>>.from(tripData['stages']);
                final allCompleted =
                    stages.every((s) => s['is_completed'] == true);

                return allCompleted &&
                        tripData['trip_status'] != 'Completed' &&
                        (userRole == 'driver' || userRole == 'admin')
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        child: _buildCompleteButton(
                            snapshot.data!.id, userRole, controller),
                      )
                    : const SizedBox.shrink();
              },
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Trip Details',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildClientInfoCard(dynamic args) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Client Information',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          _buildClientDetailRow(
            icon: Icons.person_outline_rounded,
            iconColor: Color(0xFF4A90E2),
            label: args[2] ?? 'N/A',
            sublabel: 'Client Name',
          ),
          SizedBox(height: 12.h),
          _buildClientDetailRow(
            icon: Icons.my_location_rounded,
            iconColor: Color(0xFFF59E0B),
            label: args[0] ?? 'N/A',
            sublabel: 'Pickup Location',
          ),
          SizedBox(height: 12.h),
          _buildClientDetailRow(
            icon: Icons.location_on_outlined,
            iconColor: Color(0xFF50C878),
            label: args[1] ?? 'N/A',
            sublabel: 'Destination',
          ),
        ],
      ),
    );
  }

  Widget _buildClientDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String sublabel,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStagesSection(
      TripController controller, dynamic args, String userRole) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
            child: Text(
              'Trip Stages',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.tripStreamByCreatedAt(args[3]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(40.w),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                    ),
                  ),
                );
              }

              final tripData = snapshot.data!.data();
              if (tripData == null || tripData['stages'] == null) {
                return Padding(
                  padding: EdgeInsets.all(40.w),
                  child: Center(
                    child: Text(
                      'No stages found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
              }

              final stages =
                  List<Map<String, dynamic>>.from(tripData['stages']);
              final nextIncompleteStageIndex =
                  stages.indexWhere((stage) => stage['is_completed'] == false);

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  final stage = stages[index];
                  final isCompleted = stage['is_completed'] == true;
                  final canComplete = !isCompleted &&
                      (userRole == 'admin' ||
                          index == nextIncompleteStageIndex);

                  return _buildStageItem(
                    stage: stage,
                    index: index,
                    isCompleted: isCompleted,
                    canComplete: canComplete,
                    controller: controller,
                    args: args,
                    userRole: userRole,
                    isLast: index == stages.length - 1,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStageItem({
    required Map<String, dynamic> stage,
    required int index,
    required bool isCompleted,
    required bool canComplete,
    required TripController controller,
    required dynamic args,
    required String userRole,
    required bool isLast,
  }) {
    final completedAt = stage['completed_at'] != null
        ? (stage['completed_at'] as Timestamp).toDate().toLocal()
        : null;

    return InkWell(
      onTap: canComplete
          ? () => _showStageCompletionScreen(
                context: Get.context!,
                stageName: stage['name'].toString(),
                stageIndex: index,
                controller: controller,
                args: args,
                userRole: userRole,
              )
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Row(
          children: [
            // Stage number and connector
            SizedBox(
              width: 32.w,
              child: Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Color(0xFF50C878)
                          : canComplete
                              ? Color(0xFF4A90E2)
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: canComplete
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                    ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // Stage content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage['name'].toString().tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                isCompleted ? Colors.black87 : Colors.grey[700],
                          ),
                        ),
                      ),
                      if (canComplete && !isCompleted)
                        Icon(Icons.chevron_right,
                            color: Colors.grey[400], size: 20.sp),
                    ],
                  ),
                  if (completedAt != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _formatCompletedTime(completedAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF50C878),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if (canComplete) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Tap to input time'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ] else if (!isCompleted) ...[
                    SizedBox(height: 4.h),
                    Text(
                      userRole == 'admin'
                          ? 'Previous stages must be completed first'.tr
                          : 'Awaiting Completion'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStageCompletionScreen({
    required BuildContext context,
    required String stageName,
    required int stageIndex,
    required TripController controller,
    required dynamic args,
    required String userRole,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _StageCompletionScreen(
          stageName: stageName,
          stageIndex: stageIndex,
          controller: controller,
          args: args,
          userRole: userRole,
        ),
      ),
    );
  }

  Widget _buildCompleteButton(
      String tripId, String userRole, TripController controller) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () async {
          bool shouldProceed = true;

          if (userRole == 'admin') {
            shouldProceed =
                await _showTripCompletionConfirmationDialog() ?? false;
          }

          if (shouldProceed) {
            try {
              await FirebaseFirestore.instance
                  .collection('trips')
                  .doc(tripId)
                  .update({
                'trip_status': 'Completed',
                'completed_by': userRole,
                'completed_at': FieldValue.serverTimestamp(),
              });

              Get.snackbar(
                'Trip Completed'.tr,
                userRole == 'admin'
                    ? 'Trip marked as completed by admin successfully!'.tr
                    : 'Trip marked as completed successfully!'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFF0FDF4),
                colorText: const Color(0xFF059669),
                margin: EdgeInsets.all(16.w),
                borderRadius: 12.r,
                icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
              );
              Get.offAllNamed(TRoutes.navigationBar);
            } catch (e) {
              // controller.showErrorMessage('Error'.tr, 'Something went wrong while completing the trip.'.tr);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A90E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          userRole == 'admin' ? 'Complete Trip (Admin)'.tr : 'Complete Trip'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<bool?> _showTripCompletionConfirmationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('Complete Trip'.tr),
        content: Text(
            'Are you sure you want to mark this entire trip as completed?'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('Complete'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            icon: Icons.directions_car_outlined,
            label: 'Trip',
            isActive: true,
          ),
          _buildBottomNavItem(
            icon: Icons.map_outlined,
            label: 'Map',
            isActive: false,
          ),
          _buildBottomNavItem(
            icon: Icons.history_outlined,
            label: 'History',
            isActive: false,
          ),
          _buildBottomNavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        height: 60.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Color(0xFF4A90E2) : Colors.grey[400],
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isActive ? Color(0xFF4A90E2) : Colors.grey[400],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCompletedTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}

// Stage Completion Screen (Screen 2) - Simplified for single stage
class _StageCompletionScreen extends StatelessWidget {
  final String stageName;
  final int stageIndex;
  final TripController controller;
  final dynamic args;
  final String userRole;

  const _StageCompletionScreen({
    required this.stageName,
    required this.stageIndex,
    required this.controller,
    required this.args,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Create a separate controller for this screen
    final screenController =
        Get.put(_StageCompletionController(), tag: 'stage_$stageIndex');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () {
            Get.delete<_StageCompletionController>(tag: 'stage_$stageIndex');
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Stage ${stageIndex + 1}',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage title
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              stageName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),

          // Single time picker section
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() => _buildTimeSelectionCard(screenController)),
            ),
          ),

          // Mark as done button
          Container(
            padding: EdgeInsets.all(20.w),
            child: Obx(() {
              final hasTime = screenController.selectedTime.value != null;
              return SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed:
                      hasTime ? () => _markStageAsDone(screenController) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Mark as done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionCard(_StageCompletionController screenController) {
    final hasTime = screenController.selectedTime.value != null;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: hasTime
                      ? Color(0xFF50C878).withOpacity(0.1)
                      : Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  hasTime ? Icons.check : Icons.schedule_outlined,
                  color: hasTime ? Color(0xFF50C878) : Color(0xFF4A90E2),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Completion Time',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (hasTime)
                Icon(
                  Icons.edit_outlined,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
            ],
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () => _showTimePickerDialog(screenController.selectedTime),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.grey[400],
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    hasTime
                        ? _formatDateTime(screenController.selectedTime.value!)
                        : 'Add completion time',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: hasTime ? Colors.black87 : Colors.grey[500],
                      fontWeight: hasTime ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  if (!hasTime)
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: Color(0xFF4A90E2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!hasTime) ...[
            SizedBox(height: 8.h),
            Text(
              'Not recorded',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
          ] else ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Color(0xFF50C878).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Color(0xFF50C878).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF50C878),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Time recorded successfully',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF047857),
                      fontWeight: FontWeight.w600,
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

  void _showTimePickerDialog(Rxn<DateTime> timeRx) {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(
        builder: (context) => _TimePickerScreen(
          title: 'Select Completion Time',
          onTimeSelected: (DateTime selectedTime) {
            timeRx.value = selectedTime;
          },
        ),
      ),
    );
  }

  void _markStageAsDone(_StageCompletionController screenController) async {
    final completedTime = screenController.selectedTime.value!;

    try {
      if (userRole == 'admin') {
        // Show confirmation for admin
        final confirmed = await Get.dialog<bool>(
          AlertDialog(
            title: Text('Admin Override'.tr),
            content: Text(
                'Mark "$stageName" as completed at ${_formatDateTime(completedTime)}?'
                    .tr),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('Cancel'.tr),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                ),
                child: Text('Confirm'.tr),
              ),
            ],
          ),
        );

        if (confirmed != true) return;
      }

      await controller.markTripStageWithCustomTime(
        stageIndex,
        completedTime,
        args[3],
      );

      Get.delete<_StageCompletionController>(tag: 'stage_$stageIndex');
      Navigator.pop(Get.context!); // Go back to main timeline
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to mark stage as complete'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • HH:mm').format(dateTime);
  }
}

// Simplified controller for stage completion screen
class _StageCompletionController extends GetxController {
  final selectedTime = Rxn<DateTime>();
}

// Time Picker Screen (Screen 3)
class _TimePickerScreen extends StatelessWidget {
  final String title;
  final Function(DateTime) onTimeSelected;

  const _TimePickerScreen({
    required this.title,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDate = DateTime.now().obs;
    final selectedHour = DateTime.now().hour.obs;
    final selectedMinute = DateTime.now().minute.obs;
    final selectedPeriod = (DateTime.now().hour >= 12 ? 'PM' : 'AM').obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Colors.black54, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Obx(() => SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedDate: selectedDate.value,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      selectedDate.value = args.value as DateTime;
                    },
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                    ),
                    selectionColor: Color(0xFF4A90E2),
                    todayHighlightColor: Color(0xFF4A90E2),
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                      todayTextStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ),
          ),

          // Time picker
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Hour picker
                      _buildTimePicker(
                        value: selectedHour.value > 12
                            ? selectedHour.value - 12
                            : (selectedHour.value == 0
                                ? 12
                                : selectedHour.value),
                        maxValue: 12,
                        minValue: 1,
                        onChanged: (value) {
                          if (selectedPeriod.value == 'AM') {
                            selectedHour.value = value == 12 ? 0 : value;
                          } else {
                            selectedHour.value = value == 12 ? 12 : value + 12;
                          }
                        },
                        label: selectedHour.value > 12
                            ? (selectedHour.value - 12)
                                .toString()
                                .padLeft(2, '0')
                            : selectedHour.value == 0
                                ? '12'
                                : selectedHour.value.toString().padLeft(2, '0'),
                      ),

                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                        ),
                      ),

                      // Minute picker
                      _buildTimePicker(
                        value: selectedMinute.value,
                        maxValue: 59,
                        minValue: 0,
                        onChanged: (value) {
                          selectedMinute.value = value;
                        },
                        label: selectedMinute.value.toString().padLeft(2, '0'),
                      ),

                      SizedBox(width: 20.w),

                      // AM/PM picker
                      _buildPeriodPicker(selectedPeriod, selectedHour),
                    ],
                  )),
            ),
          ),

          // Confirm button
          Container(
            padding: EdgeInsets.all(20.w),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  final finalDateTime = DateTime(
                    selectedDate.value.year,
                    selectedDate.value.month,
                    selectedDate.value.day,
                    selectedHour.value,
                    selectedMinute.value,
                  );
                  onTimeSelected(finalDateTime);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Confirm Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required int value,
    required int maxValue,
    required int minValue,
    required Function(int) onChanged,
    required String label,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            int newValue = value + 1;
            if (newValue > maxValue) newValue = minValue;
            onChanged(newValue);
          },
          child: Container(
            width: 60.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.grey[600],
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            int newValue = value - 1;
            if (newValue < minValue) newValue = maxValue;
            onChanged(newValue);
          },
          child: Container(
            width: 60.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodPicker(RxString selectedPeriod, RxInt selectedHour) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            selectedPeriod.value = selectedPeriod.value == 'AM' ? 'PM' : 'AM';
            if (selectedPeriod.value == 'AM' && selectedHour.value >= 12) {
              selectedHour.value =
                  selectedHour.value == 12 ? 0 : selectedHour.value - 12;
            } else if (selectedPeriod.value == 'PM' &&
                selectedHour.value < 12) {
              selectedHour.value =
                  selectedHour.value == 0 ? 12 : selectedHour.value + 12;
            }
          },
          child: Container(
            width: 60.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.grey[600],
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              selectedPeriod.value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            selectedPeriod.value = selectedPeriod.value == 'AM' ? 'PM' : 'AM';
            if (selectedPeriod.value == 'AM' && selectedHour.value >= 12) {
              selectedHour.value =
                  selectedHour.value == 12 ? 0 : selectedHour.value - 12;
            } else if (selectedPeriod.value == 'PM' &&
                selectedHour.value < 12) {
              selectedHour.value =
                  selectedHour.value == 0 ? 12 : selectedHour.value + 12;
            }
          },
          child: Container(
            width: 60.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
}
