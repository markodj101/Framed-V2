import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/data/models/movie_response.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';
import 'package:framed_v2/ui/home/horiz_movies.dart';
import 'package:framed_v2/ui/home/title_row.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/vert_movie_list.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:auto_route/auto_route.dart';




@RoutePage(name: 'HomeRoute')
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late MovieViewModel movieViewModel;
  Future<List<MovieResponse?>>? movieFuture;


  @override

  @override
  Widget build(BuildContext context) {
    final MovieViewModelAsync = ref.watch(movieViewModelProvider);
    return MovieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => const NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        movieFuture ??= loadData();
        return buildScreen();
      },
    );
  }

  Widget buildScreen() {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
             FutureBuilder(
              future: movieFuture,
              builder: (context, snapshot) {
                if ((snapshot.connectionState != ConnectionState.active) &&
                    (snapshot.connectionState != ConnectionState.done)) {
                  return const NotReady();
                }
                return SingleChildScrollView(
                  child: Container(
                    color: screenBackground,
                    child: Column(
                      children: [
                        HomeScreenImage(
                          movieViewModel: movieViewModel,
                          onMovieTap: (movieId) {
                            context.router.push(MovieDetailRoute(movieId: movieId));
                          },
                        ),
                        TitleRow(
                          text: 'Trending',
                          onMoreClicked: () {
                            context.router.push(ExploreRoute(movieType: MovieType.trending));
                          },
                        ),
                        HorizontalMovies(
                          movies: movieViewModel.trendingMovies,
                          onMovieTap: (movieId) {
                            context.router.push(MovieDetailRoute(movieId: movieId));
                          },
                          movieType: MovieType.trending,
                        ),
                        TitleRow(
                          text: 'Popular',
                          onMoreClicked: () {
                            context.router.push(ExploreRoute(movieType: MovieType.popular));
                          },
                        ),
                        HorizontalMovies(
                          movies: movieViewModel.popularMovies,
                          onMovieTap: (movieId) {
                            context.router.push(MovieDetailRoute(movieId: movieId));
                          },
                          movieType: MovieType.popular,
                        ),
                        TitleRow(
                          text: 'Top Rated',
                          onMoreClicked: () {
                            context.router.push(ExploreRoute(movieType: MovieType.topRated));
                          },
                        ),
                        HorizontalMovies(
                          movies: movieViewModel.topRatedMovies,
                          onMovieTap: (movieId) {
                            context.router.push(MovieDetailRoute(movieId: movieId));
                          },
                          movieType: MovieType.topRated,
                        ),
                        TitleRow(
                          text: 'Upcoming',
                          onMoreClicked: () {
                            context.router.push(ExploreRoute(movieType: MovieType.upcoming));
                          },
                        ),
                        HorizontalMovies(
                          movies: movieViewModel.upcomingMovies,
                          onMovieTap: (movieId) {
                            context.router.push(MovieDetailRoute(movieId: movieId));
                          },
                          movieType: MovieType.upcoming,
                        ),
                        const SizedBox(height: 100), // Spacing for bottom nav
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<MovieResponse?>> loadData() async {
    return Future.wait([
      movieViewModel.getTrendingMovies(1),
      movieViewModel.getTopRated(1),
      movieViewModel.getPopular(1),
      movieViewModel.getNowPlaying(1),
      movieViewModel.getUpcomingMovies(1),
    ]);
  }
}
