import 'package:flutter/material.dart';
import 'package:framed_v2/ui/home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

var index = 0;
final List<Widget> screens = <Widget>[]; //tu stigli

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
