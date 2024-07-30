import 'package:flutter/material.dart';

extension AppSize on BuildContext {
  double appWidth() {
    if (MediaQuery.sizeOf(this).width < 700) {
      return MediaQuery.sizeOf(this).width;
    } else {
      return 500;
    }
  }
}
