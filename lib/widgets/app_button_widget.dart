 import 'package:flutter/material.dart';
 import '../utils/app_colors.dart';
import 'app_shodow.dart';
import 'app_text.dart';


class AppButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  // Sizing
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  // Radius and borders
  final double? radius;
  final double borderWidth;
  final Color? borderColor;

  // Colors
  final Color? buttonColor;
  final Color? textColor;

  // Typography
  final FontWeight fontWeight;
  final double? fontSize;

  // Alignment
  final Alignment alignment;

  // Loader
  final bool loader;
  final bool isGradient,isGradientDisable;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.padding,
    this.radius,
    this.borderWidth = 1,
    this.borderColor,
    this.buttonColor,
    this.textColor,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.alignment = Alignment.center,
    this.loader = false,
    this.isGradient = false,
    this.isGradientDisable = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBorder = borderColor != null;
    final bool isDisabled = loader || onPressed == null;
    final double resolvedRadius = radius ?? 14;

    return Align(
      alignment: alignment,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: isDisabled ? 0.65 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(resolvedRadius),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isGradient ? AppColors.ctaGradient : null,
              borderRadius: BorderRadius.circular(resolvedRadius),
              boxShadow: isGradient ? AppShadows.glow : AppShadows.soft,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(resolvedRadius),
              onTap: isDisabled ? null : onPressed,
              child: Container(
                height: height,
                width: width,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: buttonColor ?? (isGradient ? Colors.transparent : AppColors.primary),
                  borderRadius: BorderRadius.circular(resolvedRadius),
                  border: hasBorder
                      ? Border.all(
                    color: borderColor!,
                    width: borderWidth,
                  )
                      : Border.all(color: Colors.transparent),
                ),
                child: loader
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: AppText(
                        text,
                        textAlign: TextAlign.center,
                        type: AppTextType.micro,
                        color: textColor ?? Colors.white,
                        fontWeight: fontWeight,
                        fontSize: fontSize ?? 16,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      suffixIcon!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class AppElevatedButton extends StatelessWidget {
  final AppButtonWidget button;

  const AppElevatedButton({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(button.radius ?? 12),
      child: button,
    );
  }
}
class AnimatedIconButton extends StatefulWidget {
  final AppButtonWidget button;

  const AnimatedIconButton({super.key, required this.button});

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(2 * _controller.value, 0),
          child: child,
        );
      },
      child: widget.button,
    );
  }
}
class GradientOutlineButton extends StatelessWidget {
  final AppButtonWidget button;

  const GradientOutlineButton({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    final radius = button.radius ?? 12;

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: AppColors().gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: button.buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: button,
      ),
    );
  }
}
