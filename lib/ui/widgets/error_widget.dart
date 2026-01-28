import 'package:flutter/material.dart';
import 'package:framed_v2/ui/widgets/status_screen.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      type: StatusType.error,
      message: errorMessage,
      onRetry: onRetry,
    );
  }
}
