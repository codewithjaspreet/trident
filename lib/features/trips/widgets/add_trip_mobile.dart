import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/utils/constants/sizes.dart';

class AddTripMobile extends StatelessWidget {
  const AddTripMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.only(
          top: TSizes.spaceBtwItems * 6,
          bottom: TSizes.spaceBtwItems * 2,
          left: TSizes.spaceBtwItems * 2,
          right: TSizes.spaceBtwItems * 2),
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Obx(
        () => PageView(
            // controller: ,

            ),
      ),
    );
  }
}
