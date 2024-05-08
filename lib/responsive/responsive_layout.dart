import 'package:flutter/material.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {super.key, required this.mobileScreen, required this.webScreen});
  final Widget mobileScreen;
  final Widget webScreen;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenWidth) {
          return webScreen;
        }
        return mobileScreen;
      },
    );
  }
}
