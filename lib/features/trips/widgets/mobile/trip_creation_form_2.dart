import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/widgets/dropdowns/custom_dropdown.dart';
import '../../../../common/widgets/textfeilds/custom_textfeild.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';
import '../page_controls.dart';

class TripCreationFormB extends StatelessWidget {
  const TripCreationFormB({super.key, required this.dashBoardController});

  final DashBoardController dashBoardController;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwItems * 4,
          horizontal: TSizes.spaceBtwItems * 2,
        ),
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: dashBoardController.tripFormKey,
            child: Column(
              children: [
                TSectionHeading(
                  title: 'Route Details',
                  rightSideWidget: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      TImages.closeIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {},
                  title: 'Source',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TDropDown(
                  items: const [
                    'UP32NM3672',
                    'UP32NM3673',
                    'UP32NM3674',
                    'UP32NM3675',
                  ],
                  hintText: 'Select Vehicle',
                  onChanged: (String? val) {
                    dashBoardController.selectedBilledVehicle.value = val!;
                  },
                  title: 'Destination',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TCustomInputField(
                  controller: dashBoardController.dieselPriceController,
                  hintText: 'Diesel Rate',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  title: 'Diesel Rate',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TCustomInputField(
                  controller:
                      dashBoardController.totalTripChargesAllocatedController,
                  hintText: 'Total Trip Charges Allocated',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  title: 'Total Trip Charges Allocated',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // make a radio button for trip type in a row

                // using google font

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Type',
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          color: Color(0xff374151),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),


                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Radio<String>(
                          value: 'OS',
                          groupValue: dashBoardController.tripType.value,
                          onChanged: (value) {
                            dashBoardController.tripType.value = value!;
                          },
                        )),
                        const Text('OS'),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Radio<String>(
                            value: 'Local',
                            groupValue: dashBoardController.tripType.value,
                            onChanged: (value) {
                              dashBoardController.tripType.value = value!;
                            },
                          )),
                          const Text('Local'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                PageControls(
                  dashBoardController: dashBoardController, formKey: dashBoardController.tripFormKey,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ));
  }
}
