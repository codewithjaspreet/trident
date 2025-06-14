import 'package:flutter/cupertino.dart';
import 'package:trident/common/widgets/layouts/templates/site_layout.dart';
import 'package:trident/features/auth/views/widgets/login_desktop_layout.dart';
import 'package:trident/features/auth/views/widgets/login_mobile_layout.dart';

class TLoginScreen extends StatelessWidget {
  const TLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(
      useLayout: false,
      desktop: LoginDesktopLayout(),
      mobile: LoginMobileLayout(),
    );
  }
}
