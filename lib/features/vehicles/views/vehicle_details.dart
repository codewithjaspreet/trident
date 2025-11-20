import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/vehicle_model.dart';
import 'edit_vehicle.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Vehicle Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black87, size: 24.sp),
            onPressed: () => Get.to(() => EditVehicleScreen(vehicle: vehicle)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vehicle Header Card
            _buildHeaderCard(),
            SizedBox(height: 16.h),

            // Basic Information Section
            _buildSectionCard(
              'Basic Information',
              Icons.info,
              [
                _buildInfoRow('Registration Number', vehicle.registrationNo),
                _buildInfoRow('Vehicle Number', vehicle.vehicleNo),
                _buildInfoRow('Owner Name', vehicle.ownerName),
                _buildInfoRow('Vehicle Type', vehicle.vehicleType),
              ],
            ),
            SizedBox(height: 16.h),

            // Vehicle Details Section
            _buildSectionCard(
              'Vehicle Details',
              Icons.local_shipping,
              [
                _buildInfoRow('Company Make', vehicle.companyMake),
                _buildInfoRow('Company Model', vehicle.companyModel),
                _buildInfoRow('Refrigerator Make/Model', vehicle.refMakeModel.isEmpty ? 'Not provided' : vehicle.refMakeModel),
              ],
            ),
            SizedBox(height: 16.h),

            // Technical Specifications Section
            _buildSectionCard(
              'Technical Specifications',
              Icons.settings,
              [
                _buildInfoRow('Chassis Number', vehicle.chassisNo.isEmpty ? 'Not provided' : vehicle.chassisNo),
                _buildInfoRow('Engine Number', vehicle.engineNo.isEmpty ? 'Not provided' : vehicle.engineNo),
                _buildInfoRow('Number of Cylinders', vehicle.noOfCylinders),
                _buildInfoRow('Tyre Size', vehicle.tyreSize.isEmpty ? 'Not provided' : vehicle.tyreSize),
              ],
            ),
            SizedBox(height: 16.h),

            // Dimensions & Capacity Section
            _buildSectionCard(
              'Dimensions & Capacity',
              Icons.straighten,
              [
                _buildInfoRow('Wheel Base (mm)', vehicle.wheelBase),
                _buildInfoRow('Gross Vehicle Weight (GVW)', vehicle.gvw),
                _buildInfoRow('Unladen Weight', vehicle.unladenWt),
                _buildInfoRow('Payload', vehicle.payload),
                _buildInfoRow('Crate Capacity', vehicle.crateCapacity),
              ],
            ),
            SizedBox(height: 16.h),

            // Registration & Compliance Section
            _buildSectionCard(
              'Registration & Compliance',
              Icons.verified,
              [
                _buildInfoRow('Registration Date', vehicle.registrationDate),
                _buildInfoRow('Fitness Date', vehicle.fitnessDate),
                _buildInfoRow('Insurance Date', vehicle.insuranceDate),
                _buildInfoRow('Road Tax Status', vehicle.roadTaxStatus),
              ],
            ),
            SizedBox(height: 16.h),

            // Additional Information Section
            _buildSectionCard(
              'Additional Information',
              Icons.more_horiz,
              [
                _buildInfoRow('NP 5 Year', vehicle.np5Year.isEmpty ? 'Not provided' : vehicle.np5Year),
                _buildInfoRow('NP Annual', vehicle.npAnnual.isEmpty ? 'Not provided' : vehicle.npAnnual),
                _buildInfoRow('Vehicle Serial Number', vehicle.vehSlNo.isEmpty ? 'Not provided' : vehicle.vehSlNo),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: TColors.bgPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.local_shipping,
              size: 32.sp,
              color: TColors.bgPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.registrationNo,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${vehicle.companyMake} ${vehicle.companyModel}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13.sp,
                    color: TColors.textSecondary,
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

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                  color: TColors.bgPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: TColors.bgPrimary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: TColors.grey),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160.w,
            child: Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: TColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: GoogleFonts.nunitoSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

