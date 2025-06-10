import 'package:flutter/cupertino.dart';
import 'package:trident/features/trips/widgets/add_trip_desktop.dart';
import 'package:trident/features/trips/widgets/add_trip_mobile.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';

class TAddTrip extends StatelessWidget{
  const TAddTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(
      desktop: AddTripDesktop(),
      mobile: AddTripMobile(),
    );
  }


}