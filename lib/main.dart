import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/templates/site_layout.dart';
import 'package:trident/routes/app_routes.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/constants/text_strings.dart';
import 'package:trident/utils/theme/theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';


import 'firebase_options.dart';

void main() async {
  //  removing hash signature from the url
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('en_IN', null);

  setPathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X base size. Adjust if needed.
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: TTexts.appName,
          themeMode: ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          getPages: TAppRoutes.allRoutes,
          initialRoute: TRoutes.loginScreen,
          builder: (context, widget) {
            // Optional for textScale fix
            ScreenUtil.init(context);
            return widget!;
          },
        );
      },
    );
  }
}
