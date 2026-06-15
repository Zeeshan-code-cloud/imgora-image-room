 import 'package:flutter/material.dart';

import '../utils/app_colors.dart';


class AppTextStyles {
  static TextStyle get xlNormal =>
      TextStyle(fontSize: 32, fontWeight: FontWeight.normal);

  static TextStyle get xlSuperBold =>
      TextStyle(fontSize: 32, fontWeight: FontWeight.w900);

  static TextStyle get heading1 =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get heading1Normal =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.normal);

  static TextStyle get heading2 =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get heading3 =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  static TextStyle get bodyText =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyTextBold =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get captionDark => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get captionPrimary => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static TextStyle get micro => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get microDark => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get microPrimary => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static TextStyle get buttonText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get appBarTitle =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle get inputText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get inputHint => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextGrey,
  );
}
