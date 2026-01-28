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
import 'package:glass_kit/glass_kit.dart';
import 'package:framed_v2/ui/screens/auth/auth_viewmodel.dart';
import 'package:framed_v2/ui/screens/auth/auth_screen.dart';
import 'package:framed_v2/ui/screens/auth/profile_screen.dart';

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
    ref.watch(authViewModelProvider);
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      loading: () => const NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        return buildScreen();
      },
    );
  }

  Widget buildScreen() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<List<Favorite>>(
          stream: getFavoritesStream(),
          builder: (context, snapshot) {
             if ((snapshot.connectionState != ConnectionState.active) &&
                (snapshot.connectionState != ConnectionState.done)) {
              return const Center(child: NotReady());
            }
            if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
            
            var favorites = snapshot.data ?? [];
            favorites = favorites.sorted((a, b) {
              switch (selectedSort) {
                case Sorting.aToz:
                  return a.title.compareTo(b.title);
                case Sorting.zToa:
                  return b.title.compareTo(a.title);
                case Sorting.rating:
                  return b.popularity.compareTo(a.popularity);
                case Sorting.year:
                  return b.releaseDate.compareTo(a.releaseDate);
              }
            });

            return LayoutBuilder(
              builder: (context, constraints) {
                return GlassContainer.frostedGlass(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    borderWidth: 1.5,
                    borderColor: Colors.white.withOpacity(0.2),
                    frostedOpacity: 0.1,
                    blur: 30,
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.5),
                    child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 40)), // Standardized top offset
                         SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SortPicker(
                                useSliver: false,
                                onSortSelected: (sorting) {
                                  setState(() {
                                    selectedSort = sorting;
                                  });
                                },
                              ),
                            ),
                          ),

                        VerticalFavoriteList(
                          favorites: favorites,
                          movieViewModel: movieViewModel,
                          onMovieTap: (movieId) {
                            context.router.push(
                              MovieDetailRoute(movieId: movieId),
                            );
                          },
                          onFavoriteResultsTap: (Favorite favorite) {
                            removeFavorite(favorite);
                          },
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),



                    Positioned(
                      top: 40,
                      left: 20,
                      right: 20,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GlassContainer.frostedGlass(
                            height: 50,
                            width: constraints.maxWidth,
                            borderRadius: BorderRadius.circular(30),
                            borderWidth: 1,
                            borderColor: Colors.white.withOpacity(0.1),
                            blur: 20,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                      Text(
                                        "Saved",
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      FutureBuilder<int>(
                                    future: _calculateTotalRuntime(favorites),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 20, 
                                          width: 20, 
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54)
                                        );
                                      }
                                      if (!snapshot.hasData) return const Text("0.0 Hours", style: TextStyle(color: Colors.white70));
                                      
                                      final totalMinutes = snapshot.data!;
                                      final hours = (totalMinutes / 60).toStringAsFixed(1);
                                      return Text(
                                        "$hours Hours Watched",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
            );
          }
        );
      }
    ),
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

  Future<int> _calculateTotalRuntime(List<Favorite> favorites) async {
    int totalMinutes = 0;
    
    final futures = favorites.map((fav) => movieViewModel.getMovieDetails(fav.movieId));
    final detailsList = await Future.wait(futures);

    for (var details in detailsList) {
      if (details != null) {
        totalMinutes += details.runtime ?? 0;
      }
    }
    return totalMinutes;
  }

  Future removeFavorite(Favorite favorite) async {
    await movieViewModel.removeFavorite(favorite.movieId);
  }
}
