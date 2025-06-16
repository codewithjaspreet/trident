import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      "hello": "Hello",
      "Accepted Trips": "Accepted Trips",
      "Rejected Trips": "Rejected Trips",
      "Assigned Trips": "Assigned Trips",
      "Assigned At": "Assigned At",
      "Use Vehicle": "Use Vehicle",
      "Type": "Type",
      "Route": "Route",
      "Updated": "Updated",
      "ago": "ago",
      "Just now": "Just now",
      "Deliver To": "Deliver To"
    },
    'hi_IN': {
      "hello": "नमस्ते",
      "Accepted Trips": "स्वीकृत",
      "Rejected Trips": "अस्वीकृत",
      "Assigned Trips": "सौंपे गए",
      "Assigned At": "सौंपा गया",
      "Use Vehicle": "वाहन चुनें",
      "Type": "प्रकार",
      "Route": "रूट",
      "Updated": "अपडेट",
      "ago": "पहले",
      "Just now": "अभी",
      "Deliver To": "डिलीवरी के लिए"
    },
  };
}
