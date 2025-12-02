import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';
import 'package:framed_v2/ui/home/horiz_movies.dart';
import 'package:framed_v2/ui/home/title_row.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/vert_movie_list.dart';

@RoutePage(name: 'HomeRoute')
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onMovieTap(int id) {
      context.router.push(MovieDetailRoute(movieId: id));
    }

    final images = ref.watch(movieImagesProvider);
    final movies = ref.read(movieImagesProvider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: screenBackground,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 24),
                    child: Text('Now Playing', style: largeTitle),
                  ),
                ),
                HomeScreenImage(
                  onMovieTap: (id) {
                    print('Movie tapped');
                    context.router.push(MovieDetailRoute(movieId: id));
                  },
                ),
                TitleRow(text: 'Trending', onMoreClicked: () {}),
                HorizontalMovies(
                  movies: movies,
                  onMovieTap: onMovieTap,
                  movieType: MovieType.trending,
                ),
                TitleRow(text: 'Popular', onMoreClicked: () {}),
                HorizontalMovies(
                  movies: images,
                  onMovieTap: onMovieTap,
                  movieType: MovieType.popular,
                ),
                TitleRow(text: 'Top Rated', onMoreClicked: () {}),
                HorizontalMovies(
                  movies: images,
                  onMovieTap: onMovieTap,
                  movieType: MovieType.topRated,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
