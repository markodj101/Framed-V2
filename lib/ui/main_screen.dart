import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/home/home_screen.dart';
import 'package:framed_v2/ui/screens/geners/genre_screen.dart';
import 'package:framed_v2/ui/screens/videos/video_page.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

@RoutePage()
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
    screens.add(VideoPage('QwW5RD02uJo'));
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      backgroundColor: screenBackground,
      routes: [HomeRoute(), GenreRoute(), FavoriteRoute()],
      bottomNavigationBuilder: (_, tabsRouter) => buildBottomBar(tabsRouter),
    );
  }

  Widget buildBottomBar(TabsRouter tabsRouter) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Symbols.genres), label: 'Genres'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
      ],

      selectedIndex: tabsRouter.activeIndex,
      onDestinationSelected: (navIndex) {
        setState(() {
          tabsRouter.setActiveIndex(navIndex);
        });
      },
    );
  }
}
