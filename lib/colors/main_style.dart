import 'package:flutter/material.dart';

class MainStyle {
  static const Color girlMessageColor = Color.fromARGB(255, 255, 192, 203);
  static const Color userMessageColor = Color.fromARGB(255, 42, 42, 42);
  static const BorderRadius girlMessageBorderRadius = BorderRadius.only(
    topLeft: Radius.zero,
    topRight: Radius.circular(8),
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
  static const BorderRadius userMessageBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.zero,
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
}
