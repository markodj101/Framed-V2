import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/data/models/movie_response.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/sliver_divider.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/screens/geners/genre_search_row.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/vert_movie_list.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/data/models/genre_state.dart';

const String genreStringKey = 'GenreKey';

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
  String currentSearchString = '';
  List<MovieResults> currentMovieList = [];
  final movieNotifier = ValueNotifier<List<MovieResults>>([]);
  MovieResponse? currentMovieResponse;
  Sorting selectedSort = Sorting.aToz;
  bool _genresLoaded = false;

  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        if (!_genresLoaded) {
          buildGenreState();
          _genresLoaded = true;
        }
        return buildScreen();
      },
    );
  }

  void buildGenreState() {
    genreStates.clear();
    for (final genre in movieViewModel.movieGenres!) {
      genreStates.add(GenreState(genre: genre, isSelected: false));
    }
    loadSelectedGenres();
  }

  void saveSelectedGenres() async {
    final prefs = await ref.read(prefsProvider.future);
    final selectedGenres = genreStates
        .where((genre) => genre.isSelected)
        .map((genre) => genre.genre.name)
        .toList();
    prefs.setString(genreStringKey, selectedGenres.join(','));
  }

  void loadSelectedGenres() async {
    final prefs = await ref.read(prefsProvider.future);

    final genreNameList = prefs.getString(genreStringKey)?.split(',');
    if (genreNameList?.isNotEmpty == true) {
      bool changed = false;
      for (final genreName in genreNameList!) {
        var genreState = genreStates.firstWhereOrNull(
          (genre) => genre.genre.name == genreName,
        );
        if (genreState != null) {
          final index = genreStates.indexOf(genreState);
          genreState = genreState.copyWith(isSelected: true);
          genreStates[index] = genreState;
          changed = true;
        }
      }
      if (changed && mounted) {
        setState(() {});
      }
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
                        currentSearchString = searchString;
                        currentMovieResponse = null;
                        FocusScope.of(context).unfocus();
                        expandedNotifier.value = false;
                        search();
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
                        onGenresSelected: (genres) {
                          genreStates = genres;
                          saveSelectedGenres();
                          currentMovieResponse = null;
                        },
                      );
                    },
                  ),
                  const SliverDivider(),
                  SortPicker(
                    useSliver: true,
                    onSortSelected: (sorting) {
                      selectedSort = sorting;
                      sortMovies();
                    },
                  ),
                  ValueListenableBuilder<List<MovieResults>>(
                    valueListenable: movieNotifier,
                    builder:
                        (
                          BuildContext context,
                          List<MovieResults> value,
                          Widget? child,
                        ) {
                          return VerticalMovieList(
                            movies: value,
                            movieViewModel: movieViewModel,
                            onMovieTap: (movieId) {
                              context.router.push(
                                MovieDetailRoute(movieId: movieId),
                              );
                            },
                          );
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

  Future<List<MovieResults>?> search() async {
    if (currentSearchString.isEmpty && genreStates.isEmpty) {
      movieNotifier.value = <MovieResults>[];
      return <MovieResults>[];
    }

    final pageNumber = (currentMovieResponse?.page == null)
        ? 1
        : (currentMovieResponse!.page + 1);

    if (currentSearchString.isNotEmpty) {
      currentMovieResponse = await movieViewModel.searchMovies(
        currentSearchString,
        pageNumber,
      );
      currentMovieList = currentMovieResponse!.results;
    }

    if (currentSearchString.isEmpty && genreStates.isNotEmpty) {
      final buffer = getGenreString();
      currentMovieResponse = await movieViewModel.searchMoviesByGenre(
        buffer.toString(),
        pageNumber,
      );
      currentMovieList = currentMovieResponse!.results;
    } else if (currentMovieList.isNotEmpty && genreStates.isNotEmpty) {
      currentMovieList = currentMovieList.where((movie) {
        for (final selectedGenre in genreStates) {
          if (movie.genreIds.contains(selectedGenre.genre.id)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    sortMovies();
    return currentMovieList;
  }

  StringBuffer getGenreString() {
    final buffer = StringBuffer();
    // Filter only selected genres
    final selected = genreStates.where((e) => e.isSelected).toList();
    for (int i = 0; i < selected.length; i++) {
        if (i > 0) {
            buffer.write('|');
        }
        buffer.write(selected[i].genre.id);
    }
    return buffer;
  }

  void sortMovies() {
    if (currentMovieList.isEmpty) {
      return;
    }
    currentMovieList = currentMovieList.sorted((a, b) {
      switch (selectedSort) {
        case Sorting.aToz:
          return a.originalTitle.compareTo(b.originalTitle);
        case Sorting.zToa:
          return b.originalTitle.compareTo(a.originalTitle);
        case Sorting.rating:
          return b.popularity.compareTo(a.popularity);
        case Sorting.year:
          if (a.releaseDate != null && b.releaseDate != null) {
            return a.releaseDate!.compareTo(b.releaseDate!);
          }
      }
      return 0;
    });
    movieNotifier.value = currentMovieList;
  }
}
