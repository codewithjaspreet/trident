import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_model.dart';

class EditVehicleScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VehicleController());

    // Initialize form with vehicle data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeEditForm(vehicle);
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
          'Edit Vehicle',
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
              // Basic Information Section
              _buildSectionHeader('Basic Information', Icons.info),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Registration Number *',
                controller: controller.registrationNoController,
                hintText: 'Enter registration number',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Registration number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Vehicle Number *',
                controller: controller.vehicleNoController,
                hintText: 'Enter vehicle number',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vehicle number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Owner Name *',
                controller: controller.ownerNameController,
                hintText: 'Enter owner name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Owner name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Vehicle Type',
                controller: controller.vehicleTypeController,
                hintText: 'e.g., LGV, HGV',
              ),

              SizedBox(height: 24.h),

              // Vehicle Details Section
              _buildSectionHeader('Vehicle Details', Icons.local_shipping),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Company Make *',
                controller: controller.companyMakeController,
                hintText: 'Enter company/manufacturer name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Company make is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Company Model *',
                controller: controller.companyModelController,
                hintText: 'Enter model name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Company model is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Refrigerator Make/Model',
                controller: controller.refMakeModelController,
                hintText: 'Enter refrigerator make/model',
              ),

              SizedBox(height: 24.h),

              // Technical Specifications Section
              _buildSectionHeader('Technical Specifications', Icons.settings),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Chassis Number',
                controller: controller.chassisNoController,
                hintText: 'Enter chassis number',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Engine Number',
                controller: controller.engineNoController,
                hintText: 'Enter engine number',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Number of Cylinders',
                controller: controller.noOfCylindersController,
                hintText: 'Enter number of cylinders',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Tyre Size',
                controller: controller.tyreSizeController,
                hintText: 'e.g., 215/75.R16 LT',
              ),

              SizedBox(height: 24.h),

              // Dimensions & Capacity Section
              _buildSectionHeader('Dimensions & Capacity', Icons.straighten),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Wheel Base (mm)',
                controller: controller.wheelBaseController,
                hintText: 'Enter wheel base',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Gross Vehicle Weight (GVW)',
                controller: controller.gvwController,
                hintText: 'Enter GVW in kg',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Unladen Weight',
                controller: controller.unladenWtController,
                hintText: 'Enter unladen weight in kg',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Payload',
                controller: controller.payloadController,
                hintText: 'Enter payload in kg',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Crate Capacity',
                controller: controller.crateCapacityController,
                hintText: 'Enter crate capacity',
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 24.h),

              // Registration & Compliance Section
              _buildSectionHeader('Registration & Compliance', Icons.verified),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Registration Date',
                controller: controller.registrationDateController,
                hintText: 'DD.MM.YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.registrationDateController, useDotFormat: true),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Fitness Date',
                controller: controller.fitnessDateController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.fitnessDateController),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Insurance Date',
                controller: controller.insuranceDateController,
                hintText: 'DD/MM/YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.insuranceDateController),
                ),
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Road Tax Status',
                controller: controller.roadTaxStatusController,
                hintText: 'DD.MM.YYYY',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: TColors.primary),
                  onPressed: () => _selectDate(context, controller.roadTaxStatusController, useDotFormat: true),
                ),
              ),

              SizedBox(height: 24.h),

              // Additional Information Section
              _buildSectionHeader('Additional Information', Icons.more_horiz),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'NP 5 Year',
                controller: controller.np5YearController,
                hintText: 'Enter NP 5 year',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'NP Annual',
                controller: controller.npAnnualController,
                hintText: 'Enter NP annual',
              ),
              SizedBox(height: 16.h),
              TCustomInputField(
                title: 'Vehicle Serial Number',
                controller: controller.vehSlNoController,
                hintText: 'Enter vehicle serial number',
              ),

              SizedBox(height: 32.h),

              // Update Button
              Obx(() => ElevatedButton(
                    onPressed: controller.isUpdating.value || vehicle.id == null
                        ? null
                        : () => controller.updateVehicle(vehicle.id!),
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
                            'Update Vehicle',
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

  Future<void> _selectDate(BuildContext context, TextEditingController dateController, {bool useDotFormat = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = useDotFormat
          ? '${picked.day}.${picked.month}.${picked.year}'
          : '${picked.day}/${picked.month}/${picked.year}';
      dateController.text = formattedDate;
    }
  }
}

