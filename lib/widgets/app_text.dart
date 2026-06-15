import 'package:flutter/material.dart';
import 'package:imageconvertor/widgets/text_style.dart';


enum AppTextType {
  xlNormal,
  xlSuperBold,
  heading1,
  heading1Normal,
  heading2,
  heading3,
  body,
  bodyBold,
  caption,
  captionDark,
  captionPrimary,
  micro,
  microDark,
  microPrimary,
  button,
  appBar,
  input,
  inputHint,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
      this.text, {
        super.key,
        this.type = AppTextType.body,
        this.color,
        this.fontWeight,
        this.fontSize,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  TextStyle _getBaseStyle() {
    switch (type) {
      case AppTextType.xlNormal:
        return AppTextStyles.xlNormal;
      case AppTextType.xlSuperBold:
        return AppTextStyles.xlSuperBold;
      case AppTextType.heading1:
        return AppTextStyles.heading1;
      case AppTextType.heading1Normal:
        return AppTextStyles.heading1Normal;
      case AppTextType.heading2:
        return AppTextStyles.heading2;
      case AppTextType.heading3:
        return AppTextStyles.heading3;
      case AppTextType.body:
        return AppTextStyles.bodyText;
      case AppTextType.bodyBold:
        return AppTextStyles.bodyTextBold;
      case AppTextType.caption:
        return AppTextStyles.caption;
      case AppTextType.captionDark:
        return AppTextStyles.captionDark;
      case AppTextType.captionPrimary:
        return AppTextStyles.captionPrimary;
      case AppTextType.micro:
        return AppTextStyles.micro;
      case AppTextType.microDark:
        return AppTextStyles.microDark;
      case AppTextType.microPrimary:
        return AppTextStyles.microPrimary;
      case AppTextType.button:
        return AppTextStyles.buttonText;
      case AppTextType.appBar:
        return AppTextStyles.appBarTitle;
      case AppTextType.input:
        return AppTextStyles.inputText;
      case AppTextType.inputHint:
        return AppTextStyles.inputHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _getBaseStyle();

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: baseStyle.copyWith(
        color: color ?? baseStyle.color,
        fontWeight: fontWeight ?? baseStyle.fontWeight,
        fontSize: fontSize ?? baseStyle.fontSize,
      ),
    );
  }
}
