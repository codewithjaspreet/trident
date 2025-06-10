import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
class TCustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String title;
  final String? helperText;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;

  const TCustomInputField({
    Key? key,
    this.controller,
    required this.title,
    this.hintText,
    this.labelText,
    this.helperText,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

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
        Material(
          color: Colors.transparent ,
          child: TextFormField(

            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            onChanged: onChanged,
            validator: validator,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            maxLines: obscureText ? 1 : maxLines,
            minLines: obscureText ? 1 : minLines,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:  TextStyle(
                color:  const Color(0XFF7D8592).withOpacity(0.6),

                fontSize: 11,
              ),
              labelText: labelText,
              helperText: helperText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding,
              border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: focusedErrorBorder,
            ),
          ),
        ),
      ],
    );
  }
}
