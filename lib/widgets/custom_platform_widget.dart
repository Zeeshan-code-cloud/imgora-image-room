import 'dart:io';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomPlatformWidget {
  static Future<void> showDefaultDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "OK",
    Color? confirmColor,
    Color? cancelColor,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                child: Text(
                  cancelText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cancelColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onCancel != null) onCancel();
                },
              ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                confirmText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: confirmColor,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onConfirm != null) onConfirm();
              },
            ),
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.black,fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey,fontSize: 16, fontWeight: FontWeight.w400),
          ),
          actions: [
            if (cancelText != null)
              TextButton(
                child: Text(
                  cancelText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cancelColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onCancel != null) onCancel();
                },
              ),
            TextButton(
              child: Text(
                confirmText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: confirmColor,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onConfirm != null) onConfirm();
              },
            ),
          ],
        ),
      );
    }
  }
}
