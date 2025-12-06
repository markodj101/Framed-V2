import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/not_ready.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/vert_favorite_list.dart';

@RoutePage(name: 'FavoriteRoute')
class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  late MovieViewModel movieViewModel;
  List<Favorite> currentFavorites = [];
  Sorting selectedSort = Sorting.aToz;
  final valueNotifier = ValueNotifier<List<Favorite>>([]);
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
    return SafeArea(
      child: StreamBuilder<List<Favorite>>(
        stream: getFavoritesStream(),
        builder: (context, snapshot) {
          if ((snapshot.connectionState != ConnectionState.active) &&
              (snapshot.connectionState != ConnectionState.done)) {
            return const NotReady();
          }
          return Scaffold(
            body: Container(
              color: screenBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                                "My Favorites",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ]),
                        ),
                        SortPicker(
                          useSliver: true,
                          onSortSelected: (sorting) {
                            selectedSort = sorting;
                            sortMovies();
                          },
                        ),
                        VerticalFavoriteList(
                          favorites: snapshot.requireData,
                          movieViewModel: movieViewModel,
                          onMovieTap: (movieId) {
                            context.router.push(
                              MovieDetailRoute(movieId: movieId),
                            );
                          },
                          onFavoriteResultsTap: (Favorite favorite) {
                            setState(() {
                              favorite.favorite = !favorite.favorite;
                              movieViewModel.updateFavorite(favorite);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stream<List<Favorite>> getFavoritesStream() {
    return movieViewModel.streamFavorites();
  }

  void sortMovies() {
    if (currentFavorites.isEmpty) {
      return;
    }
    currentFavorites = currentFavorites.sorted((a, b) {
      switch (selectedSort) {
        case Sorting.aToz:
          return a.title.compareTo(b.title);
        case Sorting.zToa:
          return b.title.compareTo(a.title);
        case Sorting.rating:
          return a.popularity.compareTo(b.popularity);
        case Sorting.year:
          return a.releaseDate.compareTo(b.releaseDate);
      }
    });
    valueNotifier.value = currentFavorites;
  }

  Future removeFavorite(Favorite favorite) async {
    setState(() {
      currentFavorites.remove(favorite);
    });
  }
}
