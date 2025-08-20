
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../utils/device/device_utility.dart';
import '../page_controls.dart';

class TripCreationFormB extends StatelessWidget {
  TripCreationFormB({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  final TripController tripController;
  final SideBarController sideBarController;
  static const Color bgPrimary = Color(0xff515DEF);

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);


    return Scaffold(
      backgroundColor: const Color(0xfff8f9ff),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDesktop),

            // Content
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: _cardDecoration(),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Route
                              _buildSectionHeader("Route Information", Icons.route_outlined),
                              SizedBox(height: 12.h),
                              _buildModernDropdown("Source", "Select Source", tripController.allSources, (val) {
                                tripController.selectedSource.value = val ?? '';
                              }),
                              SizedBox(height: 16.h),

                              /// Consignee selection
                              _buildSectionHeader("Consignee", Icons.business_outlined),
                              SizedBox(height: 12.h),
                              Obx(() {
                                final consigneeList = tripController.allConsigneesMappedToConsignor;

                                // Extract names only for the dropdown
                                final consigneeNames = consigneeList
                                    .map((c) => c['consignee'])
                                    .whereType<String>()
                                    .toList();

                                // Get current selected consignee name by matching reference
                                final selectedConsigneeRef = tripController.selectedConsignee.value?.value;
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
                                      tripController.selectedConsignee.value = Rxn<DocumentReference>(consigneeData['reference'] as DocumentReference);

                                      // ✅ Optionally set destination
                                      tripController.selectedDestination.value = consigneeData['area'] ?? '';
                                    }
                                  },
                                );
                              }),



                              SizedBox(height: 16.h),

                              /// Auto-filled Destination
                              Obx(() {
                                if (tripController.selectedDestination.value.isNotEmpty) {
                                  return _buildAutoFilledBox(
                                    "Selected Destination",
                                    tripController.selectedDestination.value,
                                    Icons.location_on,
                                    Colors.green,
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              SizedBox(height: 16.h),

                              /// Driver
                              _buildSectionHeader("Driver Information", Icons.person_outline),
                              SizedBox(height: 12.h),
                              _buildModernDropdown("Driver", "Select driver", tripController.allDrivers, (val) {
                                if (val != null) tripController.selectedDriver.value = val;
                              }),

                              SizedBox(height: 24.h),

                              /// Trip type
                              _buildSectionHeader("Trip Type", Icons.local_shipping_outlined),
                              SizedBox(height: 12.h),
                              _buildTripTypeSelector(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// --- UI helpers ---
  Widget _buildHeader(bool isDesktop) => Container(
    width: double.infinity,
    decoration: BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
    ]),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          if (!isDesktop) _buildBackButton(),
          if (!isDesktop) SizedBox(width: 12.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Route Details",
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1a1a2e),
                  )),
              SizedBox(height: 2.h),
              Text("Define your trip route and consignee details",
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  )),
            ]),
          ),
          _buildProgress("2 of 3"),
        ],
      ),
    ),
  );

  Widget _buildBackButton() => Container(
    width: 36.w,
    height: 36.w,
    decoration: BoxDecoration(
      color: const Color(0xfff8f9ff),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: Colors.grey.shade200, width: 1),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: Get.back,
        child: Center(child: Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.grey.shade700)),
      ),
    ),
  );

  Widget _buildProgress(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(color: bgPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(16.r)),
    child: Text(text, style: GoogleFonts.outfit(fontSize: 11.sp, fontWeight: FontWeight.w600, color: bgPrimary)),
  );

  Widget _buildSectionHeader(String title, IconData icon) => Row(
    children: [
      Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(color: bgPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
        child: Icon(icon, size: 16.sp, color: bgPrimary),
      ),
      SizedBox(width: 10.w),
      Text(title,
          style: GoogleFonts.outfit(
              fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xff1a1a2e))),
    ],
  );

  BoxDecoration _cardDecoration() =>
      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 3)),
      ]);

  Widget _buildModernDropdown(String title, String hintText, List<String> items, Function(String?) onChanged) {
    return TDropDown(
      items: items,
      hintText: hintText,
      onChanged: onChanged,
      title: title,
    );
  }

  Widget _buildAutoFilledBox(String label, String value, IconData icon, Color color) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: color.withOpacity(0.2), width: 1),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 18.sp),
        SizedBox(width: 8.w),
        Text(label,
            style: GoogleFonts.outfit(fontSize: 13.sp, fontWeight: FontWeight.w600, color: color)),
      ]),
      SizedBox(height: 8.h),
      Text(value,
          style: GoogleFonts.outfit(
              fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xff1a1a2e))),
    ]),
  );

  Widget _buildTripTypeSelector() => Row(
    children: [
      Expanded(child: _buildTripTypeButton("OS")),
      SizedBox(width: 12.w),
      Expanded(child: _buildTripTypeButton("Local")),
    ],
  );

  Widget _buildTripTypeButton(String type) => Obx(() => GestureDetector(
    onTap: () => tripController.tripType.value = type,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: tripController.tripType.value == type ? bgPrimary : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: tripController.tripType.value == type ? bgPrimary : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          tripController.tripType.value == type ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: tripController.tripType.value == type ? Colors.white : Colors.grey.shade500,
          size: 18.sp,
        ),
        SizedBox(width: 8.w),
        Text(type,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: tripController.tripType.value == type ? Colors.white : const Color(0xff1a1a2e),
            )),
      ]),
    ),
  ));

  Widget _buildBottomNav() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -3))],
    ),
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: PageControls(tripController: tripController, sideBarController: sideBarController),
        ),
      ),
    ),
  );
}
