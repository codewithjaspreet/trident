import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/sidebars/side_bar_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TMenuItem extends StatelessWidget {
  final String icon;
  final String route;
  final String menuName;

  const TMenuItem({
    super.key,
    required this.icon,
    required this.route,
    required this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SideBarController());

    return Obx(
          () {
        final isActive = menuController.isActive(route);
        final isHovering = menuController.isHovering(route);
        final isHighlighted = isActive || isHovering;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: InkWell(
            onTap: () => menuController.menuOnTap(route),
            onHover: (hovering) => hovering
                ? menuController.changeHoverItem(route)
                : menuController.changeHoverItem(''),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            child: Container(
              decoration: BoxDecoration(
                color: isHighlighted ? TColors.bgPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: TSizes.lg,
                      top: TSizes.sm,
                      bottom: TSizes.sm,
                      right: TSizes.sm,
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 24,
                      height: 24,
                      color: isHighlighted ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    menuName,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isHighlighted ? Colors.white : Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
