import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String labelText, [IconData? iconData]) {
  return InputDecoration(
    // icon: iconData != null ? Icon(iconData) : null,
    prefixIcon: iconData != null ? Icon(iconData) : null,
    labelText: labelText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );
}

/// Returns a sized box with default height of 12,
SizedBox addSpace({double? height, double? width}) {
  return SizedBox(
    height: height != null ? height : 12,
    width: width != null ? width : null,
  );
}
