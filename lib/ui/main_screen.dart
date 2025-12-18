import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/home/home_screen.dart';
import 'package:framed_v2/ui/screens/geners/genre_screen.dart';
import 'package:framed_v2/ui/screens/videos/video_page.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:glass_kit/glass_kit.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [HomeRoute(), GenreRoute(), FavoriteRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: screenBackground,
          body: Stack(
            children: [
              child,
              Positioned(
                left: 60,
                right: 60,
                bottom: 15,
                child: GlassContainer.frostedGlass(
                  borderColor: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.40),
                      Colors.black.withOpacity(0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  height: 75,
                  child: Container(
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(tabsRouter, 0, Icons.movie, 'Movies'),
                        _buildNavItem(
                          tabsRouter,
                          2,
                          Icons.tv,
                          'TV Shows',
                          isPlaceholder: true,
                        ),
                        _buildNavItem(
                          tabsRouter,
                          1,
                          Icons.select_all,
                          'Genres',
                        ),
                        _buildNavItem(tabsRouter, 2, Icons.favorite, 'Saved'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    TabsRouter tabsRouter,
    int index,
    IconData icon,
    String label, {
    bool isPlaceholder = false,
  }) {
    final isSelected = tabsRouter.activeIndex == index && !isPlaceholder;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (!isPlaceholder) {
            tabsRouter.setActiveIndex(index);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.transparent, // Hit test target
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 28,
                fill: isSelected ? 1.0 : 0.0, // Fill if selected (for Symbols)
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
