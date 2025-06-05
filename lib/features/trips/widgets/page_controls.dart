import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trident/features/dashboard/widgets/mobile/dashboard_mobile_layout.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class PageControls extends StatelessWidget {
  final DashBoardController dashBoardController;
  final GlobalKey<FormState> formKey;
  const PageControls({super.key, required this.dashBoardController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TRoundedContainer(
          showBorder: true,
          onTap: () {
            dashBoardController.pageIndex.value > 0
                ? dashBoardController
                    .changePage(dashBoardController.pageIndex.value - 1)
                : Get.back();
          },
          borderColor: TColors.grey.withOpacity(0.6),
          width: 124.w,
          height: 40.h,
          radius: 8.r,
          child: Center(
            child: Text(
              style: TextStyle(
                decoration: TextDecoration.none,
                color: TColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              dashBoardController.pageIndex.value == 1  ? 'Previous' : 'Cancel',
            ),
          ),
        ),
        TRoundedContainer(
          backgroundColor: TColors.bgPrimary,
          showBorder: true,
          onTap: () {

            if(dashBoardController.pageIndex.value == 1 && dashBoardController.tripFormKey.currentState!.validate()) {
              // dashBoardController.createTrip();
              Get.to(() => const DashboardMobileLayout());
            }
            dashBoardController
                .changePage(dashBoardController.pageIndex.value + 1);

            // Trigger Trip Creation Logic
          },
          borderColor: TColors.grey.withOpacity(0.6),
          width: 124.w,
          height: 40.h,
          radius: 8.r,
          child: Center(
            child: Text(
              style: TextStyle(
                decoration: TextDecoration.none,
                color: TColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              dashBoardController.pageIndex.value == 1  ? 'Save' : 'Next',

            ),
          ),
        ),
      ],
    );
  }
}
