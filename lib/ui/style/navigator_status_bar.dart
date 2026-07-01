import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigatorStatusBar {
  SystemUiOverlayStyle setStatusBar(Brightness? brightness) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: brightness,
    );
  }
}
