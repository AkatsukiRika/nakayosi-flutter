import 'package:flutter/material.dart';

class ScrollBehaviorClear extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => ClampingScrollPhysics();

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}