import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class CommonHelper {
  static void animatedSnackBar(
      BuildContext context, String body, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      body,
      type: type,
      mobileSnackBarPosition: MobileSnackBarPosition.top,
    ).show(context);
  }
}
