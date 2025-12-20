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
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent for glass effect
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
            // Apply sorting
            favorites = favorites.sorted((a, b) {
              switch (selectedSort) {
                case Sorting.aToz:
                  return a.title.compareTo(b.title);
                case Sorting.zToa:
                  return b.title.compareTo(a.title);
                case Sorting.rating:
                  return b.popularity.compareTo(a.popularity); // Descending popularity
                case Sorting.year:
                  return b.releaseDate.compareTo(a.releaseDate); // Descending year (newest first)
              }
            });

            return GlassContainer.frostedGlass(
                height: double.infinity,
                width: double.infinity,
                borderWidth: 1.5,
                borderColor: Colors.white.withOpacity(0.2), // Visible border
                frostedOpacity: 0.1, // Slight opacity to differentiate from transparent
                blur: 30, // Reduced blur slightly for sharper glass feel, or keeping high
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 140)), // Spacing for floating header
                         SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20), // Added bottom margin
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
                        const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom spacing
                      ],
                    ),

                    // Floating Header
                    Positioned(
                      top: 40,
                      left: 20,
                      right: 20,
                      child: GlassContainer.frostedGlass(
                        height: 50,
                        width: double.infinity,
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
                                future: _calculateTotalRuntime(favorites), // Pass the specific list
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
                      ),
                    ),
                  ],
                ),
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

  Future<int> _calculateTotalRuntime(List<Favorite> favorites) async { // Changed signature
    // Removed movieViewModel.getFavorites() call to rely on the passed list
    int totalMinutes = 0;
    
    // Fetch details for all favorites in parallel
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
