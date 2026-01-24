import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/home/home_screen.dart';
import 'package:framed_v2/ui/screens/geners/genre_screen.dart';
import 'package:framed_v2/ui/screens/favorites/favorite_screen.dart';
import 'package:framed_v2/ui/screens/videos/video_page.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:glass_kit/glass_kit.dart';
import 'package:framed_v2/ui/ui_utils.dart';
import 'package:framed_v2/ui/ui_utils.dart';
import 'package:framed_v2/ui/newtons_cradle_loader.dart';
import 'package:framed_v2/ui/screens/auth/auth_viewmodel.dart';
import 'package:framed_v2/ui/screens/auth/auth_screen.dart';
import 'package:framed_v2/ui/screens/auth/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';



@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var index = 0;
  final List<Widget> screens = <Widget>[];
  bool _isSavedOpen = false;
  bool _isProfileOpen = false;

  @override
  void initState() {
    super.initState();
    screens.add(HomeScreen());
    screens.add(GenreScreen());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.valueOrNull != null && (previous?.valueOrNull == null)) {
         // User logged in, close the profile overlay to show home screen
         setState(() {
           _isProfileOpen = false;
         });
      }
    });
    ref.watch(authViewModelProvider); // Watch auth state
    return AutoTabsRouter(
      routes: [HomeRoute(), GenreRoute(), FavoriteRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: screenBackground,
          body: Stack(
            children: [
              child,
              if (_isSavedOpen)
                 Positioned.fill(
                  child: FavoriteScreen(),
                ),
              if (_isProfileOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      // Close on tap outside (optional, but good UX)
                      // setState(() => _isProfileOpen = false);
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.8), // Dim background
                      child: Center(
                         child: ref.watch(authViewModelProvider).valueOrNull != null 
                            ? ProfileScreen(
                                onSignOut: () {
                                  setState(() {
                                    _isProfileOpen = false;
                                  });
                                  AutoTabsRouter.of(context).setActiveIndex(0); // Go to Home
                                },
                              )
                            : AuthScreen(
                                onLoginSuccess: () {
                                  setState(() {
                                    _isProfileOpen = false; // Close overlay on success
                                  });
                                },
                              ),
                      ),
                    ),
                  ),
                ),
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
                        _buildNavItem(
                          tabsRouter, 
                          0, 
                          Symbols.movie, 
                          'Movies', 
                          onTap: () {
                             setState(() {
                               _isSavedOpen = false;
                               _isProfileOpen = false;
                             });
                             tabsRouter.setActiveIndex(0);
                           },
                           isSelected: !_isSavedOpen && !_isProfileOpen && tabsRouter.activeIndex == 0,
                         ),
                         _buildNavItem(
                           tabsRouter, 
                           2, 
                           Symbols.favorite, 
                           'Saved',
                           onTap: () {
                             setState(() {
                               _isSavedOpen = true;
                               _isProfileOpen = false;
                             });
                             // Keep background on Home (Movies) so we see them through glass
                             if (tabsRouter.activeIndex != 0) {
                               tabsRouter.setActiveIndex(0);
                             }
                           },
                           isSelected: _isSavedOpen,
                         ),
                         _buildNavItem(
                           tabsRouter,
                           1,
                           Symbols.search,
                           'Search',
                           onTap: () {
                              setState(() {
                               _isSavedOpen = false;
                               _isProfileOpen = false;
                             });
                             tabsRouter.setActiveIndex(1);
                           },
                           isSelected: !_isSavedOpen && !_isProfileOpen && tabsRouter.activeIndex == 1,
                         ),
                         _buildNavItem(
                           tabsRouter,
                           2, 
                           Symbols.person,
                           'Profile',
                           isPlaceholder: true,
                           onTap: () {
                              setState(() {
                                _isProfileOpen = !_isProfileOpen; // Toggle
                                _isSavedOpen = false;
                              });
                           },
                           isSelected: _isProfileOpen,
                         ),
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
    VoidCallback? onTap,
    bool? isSelected,
  }) {
    final selected = isSelected ?? (tabsRouter.activeIndex == index && !isPlaceholder);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () {
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
                color: selected ? Colors.white : Colors.grey,
                size: 28,
                fill: selected ? 1.0 : 0.0, // Fill if selected (for Symbols)
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



