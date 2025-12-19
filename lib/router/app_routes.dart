import 'package:auto_route/auto_route.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/ui/home/home_screen.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_detail.dart';
import 'package:framed_v2/ui/screens/videos/video_page.dart';
import 'package:framed_v2/ui/main_screen.dart';
import 'package:framed_v2/ui/screens/favorites/favorite_screen.dart';
import 'package:framed_v2/ui/screens/geners/genre_screen.dart';
import 'package:framed_v2/ui/screens/explore/explore_screen.dart';
import 'package:flutter/material.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      initial: true,
      page: MainRoute.page,
      children: [
        AutoRoute(path: 'home', page: HomeRoute.page),
        AutoRoute(path: 'genre', page: GenreRoute.page),
        AutoRoute(path: 'favorite', page: FavoriteRoute.page),
      ],
    ),
    CustomRoute(
      path: '/explore',
      page: ExploreRoute.page,
      maintainState: true,
      opaque: false,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      path: '/details/:movieId',
      page: MovieDetailRoute.page,
      maintainState: false,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      path: '/video/:movieVideo',
      page: VideoPageRoute.page,
      maintainState: false,
      transitionsBuilder: TransitionsBuilders.slideRight,
      durationInMilliseconds: 500,
    ),
  ];
}
