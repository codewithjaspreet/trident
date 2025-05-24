import 'package:flutter/material.dart';

import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({
    super.key,
    required this.body,
  });

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const THeader(),
      drawer: const TSideBar(),
      body: body ?? const SizedBox(),
    );
  }
}
