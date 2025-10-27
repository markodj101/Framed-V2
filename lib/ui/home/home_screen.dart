import 'package:flutter/material.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color(0xFF111111),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 24),
                  child: Text(
                    'Now Playing',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              HomeScreenImage(),
            ],
          ),
        ),
      ),
    );
  }
}
