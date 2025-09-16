import 'package:flutter/cupertino.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
import '../../dashboard/widgets/desktop/dashboard_desktop_layout.dart';
import '../../dashboard/widgets/mobile/dashboard_mobile_layout.dart';

class AllTripsSection extends StatelessWidget{
  const AllTripsSection({super.key});




  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(
      desktop: DashboardDesktopLayout(),
      mobile:  DashboardMobileLayout(),
    );
  }


}