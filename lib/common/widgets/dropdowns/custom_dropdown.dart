import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';

class TDropDown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?) onChanged;
  final String title;

  const TDropDown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.title,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[

        Text(
          title,
          style: GoogleFonts.nunitoSans(
            textStyle: const TextStyle(
              color: TColors.primary,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 24 / 16,
            ),
          ),
        ),
         const SizedBox(height: TSizes.md,),

        CustomDropdown<String>(
        validator: validator,
        decoration: CustomDropdownDecoration(
          closedBorder:
          Border.all(width: 0.6, color: TColors.primary),
          closedBorderRadius: BorderRadius.circular(14),
          hintStyle: GoogleFonts.nunitoSans(
            textStyle: const TextStyle(
              color: TColors.primary,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
              fontSize: 14,
              height: 24 / 14,
            ),
          ),
        ),
        hintText: hintText,
        items: items,
        onChanged: onChanged,
      ),
    ]
    );
  }
}
