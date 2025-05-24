import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final PageController pageController = PageController();

  final curPageIndex = 0.obs;

  void changePage(int pageNo) {
    curPageIndex.value = pageNo;
  }
}
