import 'package:flutter/material.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';

import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    required this.body,
  });

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: TSideBar(),
          ),
          Expanded(
            flex: 5,
              child: Column(
            children: [
              const THeader(),
              Expanded(child: body ?? const SizedBox())
            ],
          ))
        ],
      ),
    );
  }
}
