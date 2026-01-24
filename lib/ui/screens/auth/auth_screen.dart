import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/screens/auth/auth_viewmodel.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  const AuthScreen({super.key, this.onLoginSuccess});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool clickedLogin = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.value != null) {
        // User logged in successfully
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!();
        } else {
             // Fallback if used as standalone
             if (clickedLogin) Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Overlay support
      body: Stack(
        children: [
          // Background Image (Optional)
           Positioned.fill(
            child: Container(
              color: Colors.black, // Placeholder or Image.asset
            ),
          ),
          Center(
            child: GlassContainer.clearGlass(
              height: 400,
              width: 350,
              borderRadius: BorderRadius.circular(20),
              borderColor: Colors.white.withOpacity(0.1), // Required for Web
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Welcome Back' : 'Join Framed',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController, // Added controller
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController, // Added controller
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                             clickedLogin = true;
                        });
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (_isLogin) {
                          ref.read(authViewModelProvider.notifier).signIn(email, password);
                        } else {
                          ref.read(authViewModelProvider.notifier).signUp(email, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: authState.isLoading
                          ? const CircularProgressIndicator()
                          : Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Don\'t have an account? Sign Up'
                            : 'Already have an account? Login',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    if (authState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          authState.error.toString().contains('User already registered')
                              ? 'This email is already registered. Please login instead.'
                              : authState.error.toString(),
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
