import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/trips/controllers/trip_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TripDatePickerField extends StatelessWidget {
  final TripController controller = Get.find<TripController>();

  TripDatePickerField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TextFormField(
            style: GoogleFonts.nunitoSans(
              textStyle: const TextStyle(
                color: TColors.primary,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                fontSize: 14,
                height: 24 / 14,
              ),
            ),
            readOnly: true,
            decoration: const InputDecoration(
              hintText: "Select Trip Date",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(text: controller.formattedTripDate)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: controller.formattedTripDate.length),
              ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                controller.updateTripDate(pickedDate);
              }
            },
          ),
        ],
      ),
    );
  }
}
