import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';
import 'package:trident/features/trips/controllers/trip_controller.dart';
import '../../../../common/widgets/containers/date_picker.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../utils/device/device_utility.dart';
import '../page_controls.dart';

class TripCreationFormA extends StatelessWidget {
  final TripController tripController;
  final SideBarController sideBarController;
  static const Color bgPrimary = Color(0xff515DEF);

  const TripCreationFormA({
    super.key,
    required this.tripController,
    required this.sideBarController,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = TDeviceUtils.isDesktopScreen(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff8f9ff),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    if (!isDesktop) _buildBackButton(),
                    if (!isDesktop) SizedBox(width: 12.w),

                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add New Trip",
                              style: GoogleFonts.outfit(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff1a1a2e),
                              )),
                          SizedBox(height: 2.h),
                          Text("Fill in the trip details below",
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                              )),
                        ],
                      ),
                    ),

                    // Progress
                    _buildProgress("1 of 3"),
                  ],
                ),
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Main Card
                      Container(
                        width: double.infinity,
                        decoration: _cardDecoration(),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Trip Date
                                _buildSectionHeader(
                                    "Trip Date", Icons.calendar_today_outlined),
                                SizedBox(height: 12.h),
                                TripDatePickerField(),
                                SizedBox(height: 24.h),

                                /// Billing Information
                                _buildSectionHeader("Billing Information",
                                    Icons.receipt_long_outlined),
                                SizedBox(height: 12.h),

                                if (isDesktop)
                                  Row(
                                    children: [
                                      Expanded(child: _buildBilledToDropdown()),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                          child: _buildBilledVehicleDropdown()),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      _buildBilledToDropdown(),
                                      SizedBox(height: 16.h),
                                      _buildBilledVehicleDropdown(),
                                    ],
                                  ),

                                SizedBox(height: 16.h),

                                /// Consignor Dropdown (filtered by BilledTo)
                                // Obx(() {
                                //   return _buildModernDropdown(
                                //     "Select Authorizer",
                                //     tripController.allTridentAuthorizers.isEmpty
                                //         ? "No Authorizers available"
                                //         : "Select Authorizer",
                                //     tripController.allTridentAuthorizers,
                                //     (val) {
                                //       if (val != null) {
                                //         tripController
                                //             .selectedTripAuthorizer.value = val;
                                //       }
                                //     },
                                //   );
                                // }),

                                SizedBox(height: 24.h),
                              ],
                            ),
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

      // Bottom controls
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// --- UI Helpers ---
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
            child: Center(
              child: Icon(Icons.arrow_back_ios_new,
                  size: 16.sp, color: Colors.grey.shade700),
            ),
          ),
        ),
      );

  Widget _buildProgress(String text) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: bgPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(text,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: bgPrimary,
            )),
      );

  Widget _buildSectionHeader(String title, IconData icon) => Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: bgPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 16.sp, color: bgPrimary),
          ),
          SizedBox(width: 10.w),
          Text(title,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1a1a2e),
              )),
        ],
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 3))
        ],
      );

  Widget _buildModernDropdown(String title, String hintText, List<String> items,
      Function(String?) onChanged) {
    return TDropDown(
      items: items,
      hintText: hintText,
      onChanged: onChanged,
      title: title,
    );
  }

  Widget _buildBilledToDropdown() {
    return _buildModernDropdown(
        "Billed To", "Select billing entity", tripController.allVendors, (val) {
      if (val != null) {
        tripController.selectedBilledTo.value = val;
        tripController.selectedConsignor.value = val;
        tripController.getConsigneesForSelectedConsignor();
      }
    });
  }

  Widget _buildBilledVehicleDropdown() {
    return _buildModernDropdown(
        "Billed Vehicle", "Select vehicle", tripController.allVehicles, (val) {
      if (val != null) tripController.selectedBilledVehicle.value = val;
    });
  }

  Widget _buildBottomNav() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -3))
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: PageControls(
                  tripController: tripController,
                  sideBarController: sideBarController),
            ),
          ),
        ),
      );
}
