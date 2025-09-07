import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import 'package:universal_html/js.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../utils/constants/sizes.dart';

class TripEditScreen extends StatelessWidget {
  final TripModel trip;

  const TripEditScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(
      init: TripController(),
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          state.controller?.initializeEditForm(trip);
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildAppBar(controller,context),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: controller.editFormKey,
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildCurrentValuesCard(),
                    SizedBox(height: 16.h),
                    _buildEditFieldsCard(controller),
                    SizedBox(height: 20.h),
                    _buildActionButtons(controller),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(TripController controller,   BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 18.w),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Edit Trip',
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Obx(() => Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: TextButton(
            onPressed: controller.isApproving.value
                ? null
                : () => _showApproveDropdown(controller,context),
            child: controller.isApproving.value
                ? SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              'Approve',
              style: TextStyle(
                color: const Color(0xFF16A34A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildCurrentValuesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: const Color(0xFF3B82F6),
                  size: 16.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Current Trip Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Route Display
          _buildRouteDisplay(),

          SizedBox(height: 12.h),

          // Details Grid
          _buildDetailsGrid(),
        ],
      ),
    );
  }

  Widget _buildRouteDisplay() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trip.source,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                Icons.arrow_forward,
                size: 16.w,
                color: const Color(0xFF6B7280),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TO',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trip.destination,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    final items = [
      _DetailItem('Date', _formatDate(trip.tripDate), Icons.calendar_today),
      _DetailItem('Driver', trip.driverName, Icons.person),
      _DetailItem('Vehicle', trip.billedVehicle, Icons.local_shipping),
      _DetailItem('Type', trip.tripType, Icons.category),
      _DetailItem('Billed To', trip.billedTo, Icons.business),
      _DetailItem('Authorizer', trip.selectedTripAuthorizer, Icons.verified_user),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailItem(items[i]),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: i + 1 < items.length
                      ? _buildDetailItem(items[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(_DetailItem item) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 14.w,
            color: const Color(0xFF6B7280),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditFieldsCard(TripController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                  color: const Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.edit,
                  color: const Color(0xFF059669),
                  size: 16.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Edit Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Date picker
          _buildDatePicker(controller),

          SizedBox(height: 16.h),

          // Billed To dropdown
          _buildModernDropdown(
            'Billed To',
            'Select billed to (Current: ${trip.billedTo})',
            controller.allVendors.toList(),
                (value) => controller.selectedBilledTo.value = value ?? '',
          ),

          SizedBox(height: 16.h),

          // Trip Type
          _buildModernDropdown(
            'Trip Type',
            'Select type (Current: ${trip.tripType})',
            ['OS',  'Local'],
                (value) => controller.tripType.value = value ?? '',
          ),

          SizedBox(height: 16.h),

          // Source
          _buildModernDropdown(
            'Source',
            'Select source (Current: ${trip.source})',
            controller.allSources.toList(),
                (value) => controller.selectedSource.value = value ?? '',
          ),

          SizedBox(height: 16.h),

          // // Destination
          // _buildModernDropdown(
          //   'Destination',
          //   'Select destination (Current: ${trip.destination})',
          //   controller.allDestination.toList(),
          //       (value) => controller.selectedDestination.value = value ?? '',
          // ),

          SizedBox(height: 16.h),

          // Driver
          _buildModernDropdown(
            'Driver',
            'Select driver (Current: ${trip.driverName})',
            controller.allDrivers.toList(),
                (value) => controller.selectedDriver.value = value ?? '',
          ),

          SizedBox(height: 16.h),



          // Vehicle
          _buildModernDropdown(
            'Vehicle',
            'Select vehicle (Current: ${trip.billedVehicle})',
            controller.allVehicles.toList(),
                (value) => controller.selectedBilledVehicle.value = value ?? '',
          ),




          if (trip.consignor?.isNotEmpty == true) ...[
            SizedBox(height: 16.h),
            _buildModernDropdown(
              'Consignor',
              'Select consignor (Current: ${trip.consignor})',
              controller.allConsignors.toList(),
                  (value) {
                controller.selectedConsignor.value = value ?? '';
                controller.getConsigneesForSelectedConsignor();
              },
            ),
          ],

          SizedBox(height: 16.h),
          Obx(() {
            final consigneeList = controller.allConsigneesMappedToConsignor;

            // Extract names only for the dropdown
            final consigneeNames = consigneeList
                .map((c) => c['consignee'])
                .whereType<String>()
                .toList();

            // Get current selected consignee name by matching reference
            final selectedConsigneeRef = controller.selectedConsignee.value;
            final selectedConsigneeName = selectedConsigneeRef != null
                ? consigneeList.firstWhere(
                  (c) => c['reference'] == selectedConsigneeRef,
              orElse: () => {'consignee': null},
            )['consignee']
                : null;

            return TDropDown(
              title: "Consignee",
              hintText: consigneeList.isEmpty
                  ? "No consignees available"
                  : "Choose consignee",
              items: consigneeNames,
              onChanged: (val) {
                if (val != null) {
                  final consigneeData = consigneeList.firstWhere((c) => c['consignee'] == val);

                  // ✅ Store DocumentReference in controller
                  controller.selectedConsignee = Rxn<DocumentReference>(consigneeData['reference'] as DocumentReference);

                  // ✅ Optionally set destination
                  controller.selectedDestination.value = consigneeData['area'] ?? '';
                }
              },
            );
          }),

           SizedBox(height: 16.h),

          // show the selected destination if available

          if (controller.selectedDestination.value.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selected Destination: ${controller.selectedDestination.value}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
              ),
            ),
          ],

        ],
      ),
    );
  }

  Widget _buildModernDropdown(String title, String hintText, List<String> items, Function(String?) onChanged) {
    // Show loading if items are empty
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Loading $title options...',
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return TDropDown(
      items: items,
      hintText: hintText,
      onChanged: onChanged,
      title: title,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$title is required';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker(TripController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Date',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),

        Obx(() => GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: controller.selectedTripDate.value ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              controller.updateTripDate(date);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: _hasDateChanged(controller)
                    ? const Color(0xFF059669)
                    : const Color(0xFF3B82F6),
              ),
              borderRadius: BorderRadius.circular(14.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.w,
                  color: const Color(0xFF3B82F6),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    controller.selectedTripDate.value != null
                        ? 'New: ${DateFormat('MMM dd, yyyy').format(controller.selectedTripDate.value!)}'
                        : 'Current: ${_formatDate(trip.tripDate)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_hasDateChanged(controller))
                  Icon(
                    Icons.check_circle,
                    size: 16.w,
                    color: const Color(0xFF059669),
                  ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons(TripController controller) {
    return Obx(() {
      final hasChanges = controller.hasAnyChanges();

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.isUpdating.value ? null : () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: controller.isUpdating.value || !hasChanges
                  ? null
                  : controller.updateTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasChanges
                    ? const Color(0xFF059669)
                    : const Color(0xFF9CA3AF),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: controller.isUpdating.value
                  ? SizedBox(
                height: 18.h,
                width: 18.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                hasChanges ? 'Save Changes' : 'No Changes',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  bool _hasDateChanged(TripController controller) {
    return controller.selectedTripDate.value != null &&
        controller.selectedTripDate.value != trip.tripDate;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('MMM dd, yyyy').format(date);
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

class _DetailItem {
  final String label;
  final String value;
  final IconData icon;

  _DetailItem(this.label, this.value, this.icon);
}