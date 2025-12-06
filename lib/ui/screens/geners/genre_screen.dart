import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/sliver_divider.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/screens/geners/genre_search_row.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/vert_movie_list.dart';
import 'package:framed_v2/router/app_routes.dart';

@RoutePage(name: 'GenreRoute')
class GenreScreen extends ConsumerStatefulWidget {
  const GenreScreen({super.key});

  @override
  ConsumerState<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends ConsumerState<GenreScreen> {
  final expandedNotifier = ValueNotifier<bool>(false);

  late MovieViewModel movieViewModel;
  List<GenreState> genreStates = [];
  List<Movie> currentMovieList = [];
  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        buildGenreState();
        return buildScreen();
      },
    );
  }

  void buildGenreState() {
    genreStates.clear();
    for (final genre in movieViewModel.movieGenres) {
      genreStates.add(GenreState(genre: genre, isSelected: false));
    }
  }

  Widget buildScreen() {
    return SafeArea(
      child: Container(
        color: screenBackground,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 24),
                        child: Text(
                          "Find a Movie",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GenreSearchRow((searchString) {
                        // Implement search functionality here
                        print('Searching for: $searchString');
                      }),
                    ]),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: expandedNotifier,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GenreSection(
                        genreStates: genreStates,
                        isExpanded: value,
                        onGenresExpanded: (expanded) {
                          expandedNotifier.value = expanded;
                        },
                        onGenresSelected: (List<GenreState> states) {
                          // Handle genre selection here
                        },
                      );
                    },
                  ),
                  const SliverDivider(),
                  SortPicker(
                    useSliver: true,
                    onSortSelected: (sorting) {
                      // Handle sort selection here
                    },
                  ),
                  VerticalMovieList(
                    movies: currentMovieList,
                    onMovieTap: (movieId) {
                      context.router.push(MovieDetailRoute(movieId: movieId));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
