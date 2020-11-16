
import 'package:flutter/material.dart';

class RefreshScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    // When modifying this function, consider modifying the implementation in
    // _MaterialScrollBehavior as well.
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      //case TargetPlatform.macOS:
      case TargetPlatform.android:
        return GlowingOverscrollIndicator(
          child: child,
          // this will disable top Bouncing OverScroll Indicator showing in Android
          showLeading: true,
          showTrailing: true,
          axisDirection: axisDirection,
          notificationPredicate: (notification) {
            if (notification.depth == 0) {

              if (notification.metrics.outOfRange) {
                return false;
              }
              return true;
            }
            return false;
          },
          color: Theme.of(context).primaryColor,
        );
      case TargetPlatform.fuchsia:
    }
    return null;
  }
}
