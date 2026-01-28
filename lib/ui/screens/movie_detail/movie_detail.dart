import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/data/models/movie_response.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/ui/horiz_cast.dart';
import 'package:framed_v2/ui/home/horiz_movies.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/movie_detail/button_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/detail_image.dart';
import 'package:framed_v2/ui/screens/movie_detail/horizontal_crew.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_stats_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_ai_section.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_overview.dart';



import 'package:framed_v2/ui/theme/theme.dart';



import 'package:framed_v2/providers.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:lumberdash/lumberdash.dart';



import 'package:glass_kit/glass_kit.dart';

@RoutePage(name: 'MovieDetailRoute')
class MovieDetail extends ConsumerStatefulWidget {
  final int movieId;

  const MovieDetail({@PathParam('movieId') required this.movieId, super.key});



  @override
  ConsumerState<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  late MovieViewModel movieViewModel;
  MovieCredits? credits;
  MovieVideos? movieVideos;
  MovieResponse? similarMovies;
  Future<MovieDetails?>? _movieDetailFuture;

  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => const Scaffold(
        backgroundColor: screenBackground,
        body: Center(child: NotReady()),
      ),
      data: (viewModel) {
        movieViewModel = viewModel;
        _movieDetailFuture ??= loadData();
        return buildScreen();
      },
    );
  }

  Widget buildScreen() {
    return FutureBuilder<MovieDetails?>(
      future: _movieDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: screenBackground,
            body: Center(child: NotReady()),
          );
        }
        if (snapshot.hasError) {
          logMessage('Error: ${snapshot.error.toString()}');
          return Scaffold(
            backgroundColor: screenBackground,
            body: Center(child: Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white))),
          );
        }
        final movieDetails = snapshot.data;
        if (movieDetails == null) {
          return const Scaffold(
            backgroundColor: screenBackground,
            body: Center(child: NotReady()),
          );
        }
        return Scaffold(
          backgroundColor: screenBackground,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20, top: 40), // Standardized vertical offset
              child: GestureDetector(
                onTap: () {
                   context.router.maybePop(); // Using maybePop is safer
                },
                child: GlassContainer.frostedGlass(
                  height: 50,
                  width: 50,
                  shape: BoxShape.circle,
                  borderWidth: 1,
                  borderColor: Colors.white.withOpacity(0.1),
                  blur: 20,
                  child: const Center(
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DetailImage(
                  details: movieDetails,
                  movieConfiguration: movieViewModel.movieConfiguration!,
                  onTrailerPressed: () {
                    if (movieVideos?.results.isNotEmpty ?? false) {
                      context.router.push(
                        VideoPageRoute(movieVideo: movieVideos!.results.first),
                      );
                    }
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: MovieOverview(details: movieDetails),
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<List<Favorite>>(
                  stream: movieViewModel.streamFavorites(),
                  builder: (context, snapshot) {
                    final favorites = snapshot.data ?? [];
                    final isFavorite = favorites
                        .any((element) => element.movieId == widget.movieId);
                    return ButtonRow(
                      movieId: widget.movieId,
                      favoriteSelected: isFavorite,
                      voteAverage: movieDetails.voteAverage,
                      onFavoriteSelected: () async {

                        if (isFavorite) {
                          await movieViewModel.removeFavorite(
                            widget.movieId,
                          );
                        } else {
                          await movieViewModel.saveFavorite(
                            movieDetails,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              HorizontalCast(
                castList: credits?.cast ?? [],
                movieViewModel: movieViewModel,
              ),
              HorizontalCrew(
                crewList: credits?.crew ?? [],
                movieViewModel: movieViewModel,
              ),
              MovieStatsRow(details: movieDetails),

              const MovieAiSection(),
              if (similarMovies?.results.isNotEmpty ?? false) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      "More Like This",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HorizontalMovies(
                    movies: similarMovies!.results,
                    onMovieTap: (movieId) {
                      context.router.push(
                        MovieDetailRoute(movieId: movieId),
                      );
                    },
                    movieType: MovieType.similar,
                  ),
                ),
              ],
              
              if (_directorMovies?.results.isNotEmpty ?? false) ...[
                 SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      "More from ${_directorName ?? 'Director'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HorizontalMovies(
                    movies: _directorMovies!.results,
                    onMovieTap: (movieId) {
                      context.router.push(
                        MovieDetailRoute(movieId: movieId),
                      );
                    },
                    movieType: MovieType.similar, // Reusing similar type for style
                  ),
                ),
              ],



              const SliverToBoxAdapter(
                child: SizedBox(height: 50),
              ),
            ],
          ),
        );
      },
    );
  }



  Future<MovieDetails?> loadData() async {
    credits = await movieViewModel.getMovieCredits(widget.movieId);
    movieVideos = await movieViewModel.getMovieVideos(widget.movieId);
    similarMovies = await movieViewModel.getSimilarMovies(widget.movieId, 1);
    
    // Fetch director movies
    if (credits != null) {
      final director = credits!.crew.firstWhereOrNull((c) => c.job == 'Director');
      if (director != null) {
        final directorCredits = await movieViewModel.getPersonMovieCredits(director.id);
        if (directorCredits != null) {
          // Filter out current movie without mutating the unmodifiable list
          final filteredMovies = directorCredits.results
              .where((m) => m.id != widget.movieId)
              .toList();
          
          setState(() {
            _directorMovies = directorCredits.copyWith(results: filteredMovies);
            _directorName = director.name;
          });
        }
      }
    }

    return movieViewModel.getMovieDetails(widget.movieId);
  }

  // Add variables
  MovieResponse? _directorMovies;
  String? _directorName;
}
