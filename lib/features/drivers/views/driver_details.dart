import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/driver_model.dart';
import 'edit_driver.dart';

class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

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
          'Driver Details',
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
            onPressed: () => Get.to(() => EditDriverScreen(driver: driver)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Driver Name Card
            _buildHeaderCard(),
            SizedBox(height: 16.h),

            // Personal Information Section
            _buildSectionCard(
              'Personal Information',
              Icons.person,
              [
                _buildInfoRow('Driver Name', driver.driverName),
                _buildInfoRow('Mobile Number', driver.mobileNo),
                _buildInfoRow('Date of Birth', driver.dob),
                _buildInfoRow('Marital Status', driver.maritalStatus),
                _buildInfoRow('Son Of', driver.sonOf),
                _buildInfoRow('Relative Name', driver.relativeName),
              ],
            ),
            SizedBox(height: 16.h),

            // License Information Section
            _buildSectionCard(
              'License Information',
              Icons.card_membership,
              [
                _buildInfoRow('DL Number', driver.dlNo),
                _buildInfoRow('DL Issue Date', driver.dlIssueDate),
                _buildInfoRow('DL Expiry Date', driver.dlExpiryDate),
                _buildInfoRow('NSP Number', driver.drvNspNo),
                _buildInfoRow('NSP Expiry Date', driver.nspExpiryDate),
              ],
            ),
            SizedBox(height: 16.h),

            // Identity Documents Section
            _buildSectionCard(
              'Identity Documents',
              Icons.badge,
              [
                _buildInfoRow('Aadhar Number', driver.aadharNo),
                _buildInfoRow('PAN Number', driver.panNo.isEmpty ? 'Not provided' : driver.panNo),
              ],
            ),
            SizedBox(height: 16.h),

            // Bank Information Section
            _buildSectionCard(
              'Bank Information',
              Icons.account_balance,
              [
                _buildInfoRow('Bank Account Number', driver.bankAccountNo),
                _buildInfoRow('IFSC Code', driver.ifscCode.isEmpty ? 'Not provided' : driver.ifscCode),
              ],
            ),
            SizedBox(height: 16.h),

            // Emergency Contact Section
            _buildSectionCard(
              'Emergency Contact',
              Icons.emergency,
              [
                _buildInfoRow('Emergency Contact Number', driver.emergencyContactNo),
                _buildInfoRow('Relation', driver.emergencyContactRelation),
              ],
            ),
            SizedBox(height: 16.h),

            // Additional Information Section
            _buildSectionCard(
              'Additional Information',
              Icons.info,
              [
                _buildInfoRow('Guarantor Name', driver.guarantorName),
                _buildInfoRow('Insurance Status', driver.insuranceStatus),
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
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
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
                  driver.driverName,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.phone, size: 15.sp, color: TColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text(
                      driver.mobileNo,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13.sp,
                        color: TColors.textSecondary,
                      ),
                    ),
                  ],
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
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
            width: 140.w,
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

