 import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
 import '../utils/app_colors.dart';
import 'app_shodow.dart';

class AppFormField extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isObsecured;
  final VoidCallback? onTap;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool isMultiline;
  final bool readOnly;
  final int? wordCount, maxLength;
  final bool showBorder;
  final Color? focusedBorderColor, borderColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Color? filledColor;
  final Color? textColor;
  const AppFormField({
    super.key,
    required this.title,
    this.icon,
    this.isObsecured = false,
    this.readOnly = false,
    this.onTap,
    required this.textEditingController,
    this.validator,
    this.textInputType = TextInputType.text,
    this.isMultiline = false,
    this.wordCount,
    this.borderColor,
    this.maxLength,
    this.showBorder = false,
    this.focusedBorderColor,
    this.focusNode,
    this.textInputAction,
    this.filledColor,
    this.textColor
  });

  String? _validateWordCount(String? value) {
    if (wordCount != null && value != null && value.trim().isNotEmpty) {
      final words = value.trim().split(RegExp(r'\s+'));
      if (words.length > wordCount!) {
        return 'Maximum $wordCount words allowed';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (val){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      focusNode: focusNode,
      keyboardType: isMultiline ? TextInputType.multiline : textInputType,
      validator: (value) {
        final baseValidation = validator?.call(value);
        final wordLimitValidation = _validateWordCount(value);
        return baseValidation ?? wordLimitValidation;
      },
      readOnly: readOnly,
      maxLength: maxLength,
      controller: textEditingController,
      obscureText: isObsecured,
      maxLines: isMultiline ? 5 : 1,
      textInputAction: textInputAction,
      decoration: InputDecoration(

        filled: true,
        hintText: title,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        fillColor: filledColor,
        border: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.borderColor,
            width: 1,
          ),
        )
            : InputBorder.none,

        enabledBorder: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.borderColor,
            width: 1,
          ),
        )
            : InputBorder.none,

        focusedBorder: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primary,
            width: 1.2,
          ),
        )
            : InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),

        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(icon, size: 25.px, color: AppColors.primary),
        ),
      ),
      style:  TextStyle(color: textColor),
    );
  }
}
