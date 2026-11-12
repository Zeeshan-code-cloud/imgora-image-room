import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:imageconvertor/utils/app_colors.dart';
import 'package:imageconvertor/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static final InAppReview _inAppReview = InAppReview.instance;

  /// Requests an in-app review if the API is available.
  static Future<void> requestReview() async {
    try {
      final bool isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
      }
    } catch (e) {
      debugPrint("Error requesting in-app review: $e");
    }
  }

  /// Shows the custom rating dialog.
  static Future<void> showRatingDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user has already rated the app
      final hasRated = prefs.getBool('rating_has_rated') ?? false;
      if (hasRated) {
        return;
      }

      // Increment successful operations count
      final count = (prefs.getInt('rating_success_count') ?? 0) + 1;

      if (count >= 3) {
        // Reset the counter
        await prefs.setInt('rating_success_count', 0);
        // Show dialog
        Get.dialog(
          const FeedbackDialog(),
          barrierDismissible: true,
        );
      } else {
        await prefs.setInt('rating_success_count', count);
      }
    } catch (e) {
      debugPrint("Error showing rating dialog: $e");
    }
  }

  /// Marks that the user has rated the app.
  static Future<void> markAsRated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rating_has_rated', true);
    } catch (e) {
      debugPrint("Error marking app as rated: $e");
    }
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  bool _showFeedbackForm = false;
  final String _email = 'maxkhan.03212858@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.surface0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: !_showFeedbackForm ? _buildEnjoyingState() : _buildFeedbackState(),
        ),
      ),
    );
  }

  Widget _buildEnjoyingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Text(
            "⭐",
            style: TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 20),
        const AppText(
          "Are you enjoying Imgora?",
          type: AppTextType.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const AppText(
          "Your feedback helps us make the app even better for you!",
          type: AppTextType.body,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showFeedbackForm = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const AppText(
                  "Not really 😕",
                  type: AppTextType.bodyBold,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // close dialog
                  RatingService.markAsRated();
                  RatingService.requestReview(); // trigger native in-app review
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const AppText(
                  "Yes, I love it! 😍",
                  type: AppTextType.bodyBold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              "Send Feedback",
              type: AppTextType.heading2,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
              onPressed: () => Get.back(),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const AppText(
          "We are sorry that your experience wasn't perfect. Please send us your suggestions to help us improve Imgora!",
          type: AppTextType.body,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: SelectableText(
                  _email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Copy Email',
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _email));
                    Get.snackbar(
                      "Copied",
                      "Email copied to clipboard",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 2),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.copy_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const AppText(
            "Close",
            type: AppTextType.bodyBold,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
