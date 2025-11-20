import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/driver_controller.dart';
import '../models/driver_model.dart';

class EditDriverScreen extends StatelessWidget {
  final DriverModel driver;

  const EditDriverScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController());

    // Initialize form with driver data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeEditForm(driver);
    });

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
          'Edit Driver',
          style: GoogleFonts.nunitoSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Personal Information Section
              _buildSectionHeader('Personal Information', Icons.person),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Driver Name *',
                controller: controller.driverNameController,
                hintText: 'Enter driver name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Driver name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Mobile Number *',
                controller: controller.mobileNoController,
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mobile number is required';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Date of Birth *',
                controller: controller.dobController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of birth is required';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.dobController),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Marital Status',
                controller: controller.maritalStatusController,
                hintText: 'Enter marital status',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Son Of',
                controller: controller.sonOfController,
                hintText: 'Enter father/husband name',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Relative Name',
                controller: controller.relativeNameController,
                hintText: 'Enter relative name',
              ),

              SizedBox(height: 24.h),

              // License Information Section
              _buildSectionHeader('License Information', Icons.card_membership),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'DL Number *',
                controller: controller.dlNoController,
                hintText: 'Enter driving license number',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'DL number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'DL Issue Date',
                controller: controller.dlIssueDateController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.dlIssueDateController),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'DL Expiry Date',
                controller: controller.dlExpiryDateController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.dlExpiryDateController),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'NSP Number',
                controller: controller.drvNspNoController,
                hintText: 'Enter NSP number',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'NSP Expiry Date',
                controller: controller.nspExpiryDateController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.nspExpiryDateController),
                ),
              ),

              SizedBox(height: 24.h),

              // Identity Documents Section
              _buildSectionHeader('Identity Documents', Icons.badge),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Aadhar Number *',
                controller: controller.aadharNoController,
                hintText: 'Enter Aadhar number',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Aadhar number is required';
                  }
                  if (value.length != 12) {
                    return 'Aadhar number must be 12 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'PAN Number',
                controller: controller.panNoController,
                hintText: 'Enter PAN number',
              ),

              SizedBox(height: 24.h),

              // Bank Information Section
              _buildSectionHeader('Bank Information', Icons.account_balance),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Bank Account Number',
                controller: controller.bankAccountNoController,
                hintText: 'Enter bank account number',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'IFSC Code',
                controller: controller.ifscCodeController,
                hintText: 'Enter IFSC code',
              ),

              SizedBox(height: 24.h),

              // Emergency Contact Section
              _buildSectionHeader('Emergency Contact', Icons.emergency),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Emergency Contact Number',
                controller: controller.emergencyContactNoController,
                hintText: 'Enter emergency contact number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Emergency Contact Relation',
                controller: controller.emergencyContactRelationController,
                hintText: 'Enter relation (e.g., FATHER, MOTHER)',
              ),

              SizedBox(height: 24.h),

              // Additional Information Section
              _buildSectionHeader('Additional Information', Icons.info),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Guarantor Name',
                controller: controller.guarantorNameController,
                hintText: 'Enter guarantor name',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Insurance Status',
                controller: controller.insuranceStatusController,
                hintText: 'Enter insurance status (YES/NO)',
              ),

              SizedBox(height: 32.h),

              // Update Button
              Obx(() => ElevatedButton(
                    onPressed: controller.isUpdating.value || driver.id == null
                        ? null
                        : () => controller.updateDriver(driver.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.bgPrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: controller.isUpdating.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Update Driver',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: TColors.bgPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: TColors.bgPrimary, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: GoogleFonts.nunitoSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: TColors.bgPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = '${picked.day}/${picked.month}/${picked.year}';
      controller.text = formattedDate;
    }
  }
}

