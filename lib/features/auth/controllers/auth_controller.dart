import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var loginController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  var triggerLogin = false.obs;
}
