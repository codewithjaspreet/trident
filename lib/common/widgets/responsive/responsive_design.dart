import 'package:flutter/cupertino.dart';
import 'package:trident/utils/constants/sizes.dart';

class TResponsiveWidget extends StatelessWidget {
  /// A widget that adapts its layout based on the screen size.
  /// - [mobile] is used for mobile screens.
  /// - [tablet] is used for tablet screens.
  /// - [desktop] is used for desktop screens.
  ///
  ///
  const TResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// Widget to display on mobile devices
  final Widget mobile;

  /// Widget to display on tablet devices
  final Widget tablet;

  /// Widget to display on desktop devices
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= TSizes.desktopScreenSize ) {
          return desktop;
        } else if (constraints.maxWidth < TSizes.desktopScreenSize && constraints.maxWidth >= TSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}