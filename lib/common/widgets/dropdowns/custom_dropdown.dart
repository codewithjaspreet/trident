import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/utils/constants/colors.dart';

class TDropDown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?) onChanged;

  const TDropDown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      validator: validator,
      decoration: CustomDropdownDecoration(
        closedBorder:
        Border.all(width: 0.6, color: TColors.primary),
        closedBorderRadius: BorderRadius.circular(14),
        hintStyle: GoogleFonts.nunitoSans(
          textStyle: const TextStyle(
            color: TColors.primary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 24 / 14,
          ),
        ),
      ),
      hintText: hintText,
      items: items,
      onChanged: onChanged,
    );
  }
}
