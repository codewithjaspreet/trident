import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/common/widgets/layouts/templates/site_layout.dart';
import 'package:trident/routes/app_routes.dart';
import 'package:trident/routes/routes.dart';
import 'package:trident/utils/constants/text_strings.dart';
import 'package:trident/utils/theme/theme.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {


  //  removing hash signature from the url

  setPathUrlStrategy();
  runApp(const App());
}


class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      getPages: TAppRoutes.allRoutes ,
      initialRoute: TRoutes.responsiveDesignTut,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      ),
    );

  }


  }

  class ResponsiveDesignTutorialScreen extends StatelessWidget{
  const ResponsiveDesignTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: Center(
        child: Text('Desktop Layout'),
      ),
      tablet: Center(
        child: Text('Tablet Layout'),
      ),
      mobile: Center(
        child: Text('Mobile Layout'),
      ),
    );
  }


  }

