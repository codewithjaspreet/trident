import 'package:flutter/cupertino.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
import '../widgets/desktop/dashboard_desktop_layout.dart';
import '../widgets/mobile/dashboard_mobile_layout.dart';

class DashboardScreen extends StatelessWidget{
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: DashboardDesktopLayout(),
      mobile: DashboardMobileLayout(),
    );
  }


}