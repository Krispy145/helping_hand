import 'package:flutter/material.dart';

import '../helpers/exception_mapper.dart';

extension FeedbackContextExtension on BuildContext {
  /// Show a success SnackBar
  void showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
  }

  /// Show an error SnackBar, automatically mapping exceptions to user-friendly messages
  void showErrorSnackBar(Object? error, {String? overrideMessage}) {
    if (!mounted) return;
    final message = overrideMessage ?? ExceptionMapper.map(error);
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
  }

  /// Show a consistent App Dialog
  Future<T?> showAppDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }

  /// Show a consistent Bottom Sheet
  Future<T?> showAppBottomSheet<T>({required Widget child, bool isScrollControlled = false}) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets, // Handle keyboard
        child: child,
      ),
    );
  }
}
