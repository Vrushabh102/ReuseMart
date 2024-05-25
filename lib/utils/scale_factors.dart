import 'dart:developer';

import 'package:flutter/material.dart';

class ScaleFactors {
  // screen sizes of external design source
  final _designScreenWidth = 193.08;
  final _designScreenHeight = 492.06;

  // function to return the width scale factor for any screen size
  double widthScaleFactor(BuildContext context) {
    log('width of media query ${MediaQuery.of(context).size.width}');
    log('width scale factor ${MediaQuery.of(context).size.width/_designScreenWidth}');
    return MediaQuery.of(context).size.width / _designScreenWidth;
  }

  // function to return the height scale factor for any screen size
  double heightScaleFactor(BuildContext context) {
       log('height of media query ${MediaQuery.of(context).size.height}');
    log('height scale factor ${MediaQuery.of(context).size.height/_designScreenHeight}');
    return MediaQuery.of(context).size.height / _designScreenHeight;
  }
}
