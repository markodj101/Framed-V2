import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/services/auth_service.dart';
import 'package:framed_v2/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    try {
      state = AsyncValue.data(_authService.currentUser);
      _authService.authStateChanges.listen((data) {
        state = AsyncValue.data(data.session?.user);
      }, onError: (e) {
        print('AuthViewModel: Error listening to auth state changes: $e');
        state = AsyncValue.error(e, StackTrace.current);
      });
    } catch (e, st) {
      print('AuthViewModel: Error initializing: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signIn(email, password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signUp(email, password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  return AuthViewModel(ref.watch(authServiceProvider));
});
