import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/utils/constants/colors.dart';
import 'package:trident/utils/constants/sizes.dart';

import '../../../../utils/constants/image_strings.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.iconImage,
    required this.value,
    required this.percentage,
    required this.updateDate,
    this.iconBackgroundColor = const Color(0xFFF5F3FF),
  });

  final String title;
  final String iconImage;
  final int value;
  final String percentage;
  final String updateDate;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TRoundedContainer(
        showBorder: true,
        borderColor: TColors.primary.withOpacity(0.3),
        width: 313,
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Row(
              children: [
                TRoundedContainer(
                  showBorder: true,
                  borderColor: TColors.borderPrimary.withOpacity(0.1),
                  backgroundColor: iconBackgroundColor,
                  radius: 12,
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    iconImage,
                    color: const Color(0xff7152F3),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      height: 22 / 14,
                      fontWeight: FontWeight.w300,
                      color: TColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Value
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: TSizes.sm),
                    child: Text(
                      value.toString(),
                      style: GoogleFonts.lexend(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TRoundedContainer(
                    radius: 5,
                    backgroundColor: const Color(0xff30BE82).withOpacity(0.2),
                    width: 54,
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm, vertical: TSizes.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            width: 12,
                            height: 12,
                            TImages.upArrow,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          percentage,
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// Update Text
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Text(
                'Update: $updateDate',
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
