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
import 'package:framed_v2/ui/horiz_cast.dart';
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
  Future<MovieDetails?>? _movieDetailFuture;

  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => const NotReady(),
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
          return const NotReady();
        }
        if (snapshot.hasError) {
          logMessage('Error: ${snapshot.error.toString()}');
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        final movieDetails = snapshot.data;
        if (movieDetails == null) {
          return const NotReady();
        }
        return Scaffold(
          backgroundColor: screenBackground,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: GestureDetector(
                onTap: () => context.router.back(),


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
    return movieViewModel.getMovieDetails(widget.movieId);
  }
}
