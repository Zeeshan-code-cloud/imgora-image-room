// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const Color primary = Color(0xFF960FFF);
//   static const Color secondary = Color(0xFFF5E7FF);
//   static const Color accentDark = Color(0xFF348AC7);
//   static const Color accent = Color(0xFF79D0FF);
//
//   static const Color textPrimary = Color(0xFF6C5CE7);
//   static const Color textSecondary = Color(0xFF4F5B67);
//   static const Color textSecondaryDark = Color(0xFFBFD1E5);
//   static const Color hintTextGrey = Color(0xFFDDDADA);
//   static const Color textGrey = Color(0xFF858585);
//   static const Color textGrey1 = Color(0xFF9A9A9A);
//   static const Color textGrey2 = Color(0xFF696F8C);
//
//   static const Color cardBg = Color(0xFFF0F0F0);
//   static const Color borderColor = Color(0xFFA8A8A8);
//
//
//   static const Color surfaceDark = Color(0xFF15223A);
//   static const Color fieldColor = Color(0xFF192A52);
//
//   static const Color white = Colors.white;
//   static const Color black = Colors.black;
//
//   static const Color error = Colors.redAccent;
//   static const Color emergencyColor = Color(0xFFFFB7B8);
//   static const Color success = Colors.green;
//
//   final gradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [
//       Color(0xFF7ED6D3),
//       Color(0xFFB77CF5),
//       Color(0xFF9A9CF6),
//     ],
//   );
// }


import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFFE5DEFF);
  static const Color accentDark = Color(0xFF06B6D4);
  static const Color accent = Color(0xFF22D3EE);

  // Typography (now tuned for light surfaces)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF475569);
  static const Color hintTextGrey = Color(0xFF94A3B8);
  static const Color textGrey = Color(0xFF98A2BE);
  static const Color textGrey1 = Color(0xFFCBD5E1);
  static const Color textGrey2 = Color(0xFF64748B);

  // Typography - Light
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color hintTextGreyLight = Color(0xFF94A3B8);

  // Layered surfaces (switched to light palette)
  static const Color surface0 = Color(0xFFFFFFFF);
  static const Color surface1 = Color(0xFFF8FAFC);
  static const Color surface2 = Color(0xFFF1F5F9);
  static const Color cardBg = surface1;
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color surfaceDark = Color(0xFFE2E8F0);
  static const Color fieldColor = Color(0xFFF1F5F9);
  // Overlays tuned for light mode (subtle dark scrims)
  static const Color overlayLight = Color(0x14000000);
  static const Color overlayStrong = Color(0x26000000);

  // Layered surfaces - Light
  static const Color surfaceLight0 = Color(0xFFFFFFFF);
  static const Color surfaceLight1 = Color(0xFFF8FAFC);
  static const Color surfaceLight2 = Color(0xFFF1F5F9);
  static const Color cardBgLight = surfaceLight1;
  static const Color borderColorLight = Color(0xFFE2E8F0);
  static const Color fieldColorLight = Color(0xFFF1F5F9);

  // Basic
  static const Color white = Colors.white;
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF1E293B);

  // Status
  static const Color error = Color(0xFFFF5A76);
  static const Color emergencyColor = Color(0xFF4A1F2A);
  static const Color success = Color(0xFF34D399);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9E7EFF), Color(0xFF5F9BFF), Color(0xFF3AD9FF)],
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9B7BFF),
      Color(0xFF3DD7FF),
    ],
  );

  final LinearGradient gradient = ctaGradient;
}