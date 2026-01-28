import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum ConnectivityStatus {
  isConnected,
  isDisconnected,
  checking,
}

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityNotifier() : super(ConnectivityStatus.checking) {
    _init();
  }

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription<InternetStatus> _internetSubscription;

  void _init() async {
    // Initial check
    await checkConnectivity();

    // Listen for connectivity changes (Wi-Fi, Mobile, etc.)
    // Note: older versions returned ConnectivityResult, newer might return List<ConnectivityResult>
    // Adjusting for potential List<ConnectivityResult> or single ConnectivityResult depending on package version.
    // Assuming latest connectivity_plus which might return List<ConnectivityResult> in streams or single.
    // For safety with 'connectivity_plus', we'll handle the stream carefully.
    
    // Actually, let's just stick to InternetConnectionCheckerPlus for the "Internet" check primarily.
    // But ConnectivityPlus is good for immediate network interface changes.
    
    _internetSubscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        state = ConnectivityStatus.isConnected;
      } else {
        state = ConnectivityStatus.isDisconnected;
      }
    });
  }

  Future<void> checkConnectivity() async {
    state = ConnectivityStatus.checking;
    bool result = await InternetConnection().hasInternetAccess;
    if (result) {
      state = ConnectivityStatus.isConnected;
    } else {
      state = ConnectivityStatus.isDisconnected;
    }
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }
}

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>((ref) {
  return ConnectivityNotifier();
});
