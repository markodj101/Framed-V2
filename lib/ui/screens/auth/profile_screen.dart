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
    return Scaffold(
      backgroundColor: Colors.transparent, // Or transparent if overlay
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.outfit()),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: GlassContainer.clearGlass(
              height: 400,
              width: 350,
              borderRadius: BorderRadius.circular(20),
              borderColor: Colors.white.withOpacity(0.1), // Required for Web
              padding: const EdgeInsets.all(20),
          child: _loading 
            ? const Center(child: CircularProgressIndicator()) 
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   TextField(
                      controller: _usernameController, 
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
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
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    child: const Text('Update Profile'),
                  ),
                   const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authViewModelProvider.notifier).signOut();
                      if (widget.onSignOut != null) {
                        widget.onSignOut!();
                      }
                      // No Navigator.pop() as it's an overlay
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
