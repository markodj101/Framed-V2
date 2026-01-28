import 'package:flutter/material.dart';
import 'package:framed_v2/ui/widgets/status_screen.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback onRefresh;

  const OfflineScreen({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      type: StatusType.offline,
      onRetry: onRefresh,
    );
  }
}
