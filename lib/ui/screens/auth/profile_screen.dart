import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/screens/auth/auth_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSignOut;
  const ProfileScreen({super.key, this.onSignOut});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _loading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      _usernameController.text = (data['username'] ?? '') as String;
      // _websiteController.text = (data['website'] ?? '') as String; // Website not in schema, ignoring
    } on PostgrestException catch (error) {
      // Create profile if not exists or error
       print("Error loading profile: ${error.message}");
    } catch (error) {
       print("Error loading profile: $error");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final user = Supabase.instance.client.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await Supabase.instance.client.from('profiles').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } on PostgrestException catch (error) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, 
      child: Center(
        child: GlassContainer.frostedGlass(
          height: 450,
          width: 350,
          borderRadius: BorderRadius.circular(30),
          borderWidth: 1,
          borderColor: Colors.white.withOpacity(0.1),
          blur: 20,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          padding: const EdgeInsets.all(24),
          child: _loading 
            ? const Center(child: CircularProgressIndicator(color: Colors.white)) 
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Avatar Placeholder (optional, keeping it simple for now)
                   Container(
                     height: 80,
                     width: 80,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Colors.white.withOpacity(0.1),
                       border: Border.all(color: Colors.white.withOpacity(0.2)),
                     ),
                     child: const Icon(Icons.person, size: 40, color: Colors.white),
                   ),
                   const SizedBox(height: 32),

                   // Username Input (Glass Pill)
                   LayoutBuilder(
                     builder: (context, constraints) {
                       return GlassContainer.frostedGlass(
                         height: 60,
                         width: constraints.maxWidth,
                         borderRadius: BorderRadius.circular(30),
                         borderWidth: 1,
                         borderColor: Colors.white.withOpacity(0.1),
                         blur: 15,
                         gradient: LinearGradient(
                           colors: [
                             Colors.white.withOpacity(0.05),
                             Colors.white.withOpacity(0.02),
                           ],
                         ),
                         child: Center(
                           child: TextField(
                              controller: _usernameController, 
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                              ),
                            ),
                         ),
                       );
                     }
                   ),

                  const SizedBox(height: 32),
                  
                  // Update Button
                  GestureDetector(
                    onTap: _updateProfile,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GlassContainer.frostedGlass(
                          height: 50,
                          width: constraints.maxWidth,
                          borderRadius: BorderRadius.circular(25),
                          borderWidth: 1,
                          borderColor: Colors.white.withOpacity(0.2),
                          blur: 10,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Update Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),

                   const SizedBox(height: 16),

                  // Sign Out Button
                  TextButton(
                    onPressed: () {
                      ref.read(authViewModelProvider.notifier).signOut();
                      if (widget.onSignOut != null) {
                        widget.onSignOut!();
                      }
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
