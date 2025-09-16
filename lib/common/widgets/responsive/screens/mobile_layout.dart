import 'package:flutter/material.dart';

import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
    required this.body,
  });

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const THeader(),
      // drawer: const TSideBar(),
      body: body ?? const SizedBox(),
    );
  }
}
