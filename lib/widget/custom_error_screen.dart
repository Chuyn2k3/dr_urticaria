import 'package:flutter/material.dart';
import '../../../constant/color.dart';
import 'appbar/custom_app_bar.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showAppBar;

  const ErrorScreen({
    Key? key,
    this.message = "Đã xảy ra lỗi",
    this.onRetry,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: showAppBar
          ? CustomAppbar.basic(
              backgroundColor: AppColors.primaryColor,
              widgetTitle: const Text(
                'Lỗi',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: Navigator.canPop(context)
                  ? () => Navigator.pop(context)
                  : null,
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red[700]),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text("Thử lại"),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
