import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/horiz_cast.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/movie_detail/button_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/detail_image.dart';
import 'package:framed_v2/ui/screens/movie_detail/genre_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_overview.dart';
import 'package:framed_v2/ui/screens/movie_detail/trailer.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:lumberdash/lumberdash.dart';

@RoutePage(name: 'MovieDetailRoute')
class MovieDetail extends ConsumerStatefulWidget {
  final int movieId;

  const MovieDetail(this.movieId, {super.key});

  @override
  ConsumerState<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  late MovieViewModel movieViewModel;
  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => const NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        return buildScreen();
      },
    );
  }

  Widget buildScreen() {
    final favoriteNotifier = ValueNotifier<bool>(false);

    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const NotReady();
        }
        if (snapshot.hasError) {
          logMessage('Error: ${snapshot.error.toString()}');
          return Text(snapshot.error.toString());
        }
        final movieDetails = snapshot.data as MovieDetails?;
        if (movieDetails == null) {
          return const NotReady();
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: screenBackground,
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  context.router.maybePopTop();
                },
              ),
              centerTitle: false,
              title: Text(
                'Back',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            body: Container(
              color: screenBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Stack(
                              children: [DetailImage(details: movieDetails)],
                            ),
                            GenreRow(genres: movieDetails.genres),
                            MovieOverview(details: movieDetails),
                            ValueListenableBuilder<bool>(
                              valueListenable: favoriteNotifier,
                              builder:
                                  (
                                    BuildContext context,
                                    bool value,
                                    Widget? child,
                                  ) {
                                    return ButtonRow(
                                      favoriteSelected: favoriteNotifier.value,
                                      onFavoriteSelected: () async {
                                        favoriteNotifier.value =
                                            !favoriteNotifier.value;
                                      },
                                    );
                                  },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                bottom: 8,
                              ),
                              child: Text(
                                "Trailers",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                            ),
                            Trailer(
                              movieVideos: [
                                "https://img.youtube.com/vi/U2Qp5pL3ovA/hqdefault.jpg",
                              ],
                              onVideoTap: (video) {
                                context.router.push(
                                  VideoPageRoute(movieVideo: "U2Qp5pL3ovA"),
                                );
                              },
                            ),
                          ]),
                        ),
                        HorizontalCast(castList: ["", ""]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future loadData() async {
    return movieViewModel.getMovieDetails(widget.movieId);
  }
}
