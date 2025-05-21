import 'package:flutter/material.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';

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
            child: Drawer(),
          ),
          Expanded(
            flex: 5,
              child: Column(
            children: [
              TRoundedContainer(
                width: double.infinity,
                height: 75,
                backgroundColor: Colors.yellow.withOpacity(0.2),
              ),
              body ?? const SizedBox()
            ],
          ))
        ],
      ),
    );
  }
}
