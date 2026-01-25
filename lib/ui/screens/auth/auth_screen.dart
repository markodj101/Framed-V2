import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/screens/auth/auth_viewmodel.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  const AuthScreen({super.key, this.onLoginSuccess});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool clickedLogin = false;
  bool _obscurePassword = true;

  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      if (error.statusCode == '400' && error.message.contains('Invalid login credentials')) {
        return 'Wrong email or password (400).'; // Specific request compliance
      }
      if (error.message.contains('User already registered')) {
        return 'Email already used. Please login instead.';
      }
      return error.message; // Return Supabase message directly if no override
    }
    
    final message = error.toString();
    if (message.contains('SocketException') || message.contains('Failed host lookup')) {
      return 'Network error. Please check your connection.';
    }
    return message;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in red.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      clickedLogin = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLogin) {
      await ref.read(authViewModelProvider.notifier).signIn(email, password);
    } else {
      final response = await ref.read(authViewModelProvider.notifier).signUp(email, password);
       // Check for email verification case (success but no session)
       if (response != null && response.session == null && response.user != null) {
          if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account created! Please check your email to verify.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 5),
                ),
              );
          }
           return; 
       }
    }

    // Check for error in state
    final authState = ref.read(authViewModelProvider);
    if (authState.hasError && mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(authState.error)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.valueOrNull != null && (previous?.valueOrNull == null)) {
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!();
        } else {
             if (clickedLogin) Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Overlay support
      body: Stack(
        children: [
           // Dark Gradient Background
           Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A1A1A),
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),



                      // Inputs
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                           // Validation logic preserved
                          if (value == null || value.isEmpty) return 'Email cannot be empty';
                          final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF2C2C2E),
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password cannot be empty';
                        if (value.length < 6) return 'Must be at least 6 characters';
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF2C2C2E),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white38),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white38,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),



                    // Continue Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white10),
                          ),
                        ),
                        child: authState.isLoading
                             ? const CircularProgressIndicator(color: Colors.white)
                             : Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Toggle Link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                           setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.white54),
                            children: [
                              TextSpan(text: _isLogin ? 'Not a Member? ' : 'Already a Member? '),
                              TextSpan(
                                text: _isLogin ? 'Create an Account' : 'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}


