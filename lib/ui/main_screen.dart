import 'package:flutter/material.dart';
import 'package:framed_v2/ui/home/home_screen.dart';
import 'package:framed_v2/ui/screens/geners/genre_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var index = 0;
  final List<Widget> screens = <Widget>[];

  @override
  void initState() {
    super.initState();
    screens.add(HomeScreen());
    screens.add(GenreScreen());
    screens.add(const Placeholder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Genre'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: index,
        onTap: (navIndex) {
          setState(() {
            index = navIndex;
          });
        },
      ),
    );
  }
}
