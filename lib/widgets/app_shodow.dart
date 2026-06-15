import 'package:flutter/material.dart';

class AppSizes {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xlg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadii {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(100));
}

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x3D000000), blurRadius: 22, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x3B8B5CF6), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
