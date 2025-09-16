import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../constants/enums.dart';

class THelperFunctions {

  static DateTime getStartOfWeek(DateTime date) {
    final int daysUntilMonday = date.weekday - 1;
    final DateTime startOfWeek = date.subtract(Duration(days: daysUntilMonday));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
  }

  static Color getOrderStatusColor(OrderStatus value) {
    if (OrderStatus.pending == value) {
      return Colors.blue;
    } else if (OrderStatus.processing == value) {
      return Colors.orange;
    } else if (OrderStatus.shipped == value) {
      return Colors.purple;
    } else if (OrderStatus.delivered == value) {
      return Colors.green;
    } else if (OrderStatus.cancelled == value) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }
  static  Future<String> getLoggedInUserRole() async{

    return await GetStorage().read('user_role');
  }

  static String formatIndianDateTime(String dateTimeString) {
    try {
      DateTime? parsedDateTime;

      // Handle format like "2025-09-10 20:48:28.508"
      if (dateTimeString.contains(' ') && dateTimeString.contains(':')) {
        final parts = dateTimeString.split(' ');
        final datePart = parts[0]; // 2025-09-10
        final timePart = parts[1]; // 20:48:28.508

        final dateComponents = datePart.split('-');
        final timeComponents = timePart.split(':');

        if (dateComponents.length == 3 && timeComponents.length >= 2) {
          final year = int.parse(dateComponents[0]);
          final month = int.parse(dateComponents[1]);
          final day = int.parse(dateComponents[2]);
          final hour = int.parse(timeComponents[0]);
          final minute = int.parse(timeComponents[1]);

          parsedDateTime = DateTime(year, month, day, hour, minute);
        }
      }
      // Handle ISO format: 2025-09-10T15:41:115
      else if (dateTimeString.contains('T')) {
        parsedDateTime = DateTime.parse(dateTimeString);
      }
      // Handle simple date format: 2025-09-10
      else if (dateTimeString.contains('-')) {
        parsedDateTime = DateTime.parse(dateTimeString);
      }

      if (parsedDateTime != null) {
        // Get day with suffix (1st, 2nd, 3rd, 4th, etc.)
        String getDayWithSuffix(int day) {
          if (day >= 11 && day <= 13) return '${day}th';
          switch (day % 10) {
            case 1:
              return '${day}st';
            case 2:
              return '${day}nd';
            case 3:
              return '${day}rd';
            default:
              return '${day}th';
          }
        }

        // Get month name
        List<String> months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        final dayWithSuffix = getDayWithSuffix(parsedDateTime.day);
        final monthName = months[parsedDateTime.month - 1];
        final year = parsedDateTime.year;

        // Format time as 12-hour with am/pm
        final hour12 = parsedDateTime.hour == 0 ? 12 :
        parsedDateTime.hour > 12 ? parsedDateTime.hour - 12 : parsedDateTime
            .hour;
        final amPm = parsedDateTime.hour >= 12 ? 'pm' : 'am';
        final minute = parsedDateTime.minute.toString().padLeft(2, '0');

        return '$dayWithSuffix $monthName, $year at $hour12:$minute $amPm';
      }

      return dateTimeString;
    } catch (e) {
      // Debug: Print the original string to see what format you're getting
      print('Date parsing error for: $dateTimeString');
      return dateTimeString;
    }
  }
  }