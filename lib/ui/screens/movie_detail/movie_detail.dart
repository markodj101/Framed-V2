import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/horiz_cast.dart';
import 'package:framed_v2/ui/screens/movie_detail/button_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/detail_image.dart';
import 'package:framed_v2/ui/screens/movie_detail/genre_row.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_overview.dart';
import 'package:framed_v2/ui/screens/movie_detail/trailer.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/providers.dart';

@RoutePage(name: 'MovieDetailRoute')
class MovieDetail extends ConsumerStatefulWidget {
  final int movieId;

  const MovieDetail(this.movieId, {super.key});

  @override
  ConsumerState<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    final favoriteNotifier = ValueNotifier<bool>(false);
    final genres = ref.read(genresProvider);
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
                        Stack(children: [DetailImage()]),
                        GenreRow(genres: genres),
                        MovieOverview(
                          details:
                              'Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.',
                        ),
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
                                    if (favoriteNotifier.value) {
                                      favoriteNotifier.value = false;
                                    } else {
                                      favoriteNotifier.value = true;
                                    }
                                  },
                                );
                              },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Text(
                            "Trailers",
                            style: Theme.of(context).textTheme.headlineLarge,
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
  }
}
