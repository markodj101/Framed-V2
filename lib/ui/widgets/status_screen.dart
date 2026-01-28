import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

enum StatusType { offline, error }

class StatusScreen extends StatelessWidget {
  final StatusType type;
  final String? message;
  final VoidCallback onRetry;

  const StatusScreen({
    super.key,
    required this.type,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isOffline = type == StatusType.offline;
    
    String title = isOffline ? "No Internet Connection" : "Something went wrong";
    IconData icon = isOffline ? Icons.signal_wifi_off_rounded : Icons.error_outline_rounded;
    
    String displayMessage = message ?? (isOffline 
        ? "Please check your internet connection and try again." 
        : "An unexpected error occurred.");
    
    if (message != null) {
      if (message!.contains("SocketException") || message!.contains("GenericIOException")) {
        displayMessage = "Network Connection Error. Please check your internet.";
      }
    }

    return Scaffold(
      backgroundColor: Colors.black45, // Slight dim for the whole screen
      body: Center(
        child: GlassContainer.frostedGlass(
          height: 350,
          width: 320,
          borderRadius: BorderRadius.circular(30),
          borderWidth: 1.5,
          borderColor: Colors.white.withOpacity(0.15),
          blur: 25,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 60, color: Colors.white70),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      displayMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    child: Text(
                      isOffline ? "Refresh" : "Retry",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
