import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/movie_widget.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/vert_movie_list.dart';
import 'package:glass_kit/glass_kit.dart';



@RoutePage()
class ExploreScreen extends ConsumerStatefulWidget {
  final MovieType movieType;

  const ExploreScreen({
    super.key,
    required this.movieType,
  });

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch to ensure we have at least 30 movies (2 pages = 40 movies)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialFetch();
    });
  }

  Future<void> _initialFetch() async {
    final viewModel = ref.read(movieViewModelProvider).value;
    if (viewModel != null) {
      // Clear and fetch first page
      await _fetchPage(viewModel, 1, append: false);
      // Fetch second page immediately to reach 30+ movies
      await _fetchPage(viewModel, 2, append: true);
    }
  }

  Future<void> _fetchPage(MovieViewModel viewModel, int page, {bool append = true}) async {
    switch (widget.movieType) {
      case MovieType.trending:
        await viewModel.getTrendingMovies(page, append: append);
        break;
      case MovieType.popular:
        await viewModel.getPopular(page, append: append);
        break;
      case MovieType.topRated:
        await viewModel.getTopRated(page, append: append);
        break;
      case MovieType.nowPlaying:
        await viewModel.getNowPlaying(page, append: append);
        break;
      case MovieType.upcoming:
        await viewModel.getUpcomingMovies(page, append: append);
        break;
      case MovieType.similar:
         // Not supported in ExploreScreen yet
        break;
    }
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    final viewModel = ref.read(movieViewModelProvider).value;
    if (viewModel == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    await viewModel.loadMore(widget.movieType);

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: movieViewModelAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (viewModel) {
          final movies = _getMovies(viewModel);
          return GlassContainer.frostedGlass(
            height: double.infinity,
            width: double.infinity,
            borderWidth: 0,
            borderColor: Colors.transparent,
            blur: 40, // More blur for the background
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 140)), // Increased spacing for floating header
                    VerticalMovieList(
                      movies: movies,
                      movieViewModel: viewModel,
                      onMovieTap: (movieId) {
                        context.router.push(MovieDetailRoute(movieId: movieId));
                      },
                    ),
                    if (_isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator(color: Colors.white)),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
                
                // Modular Floating Header
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        onTap: () => context.router.back(),
                        child: GlassContainer.frostedGlass(
                          height: 50,
                          width: 50,
                          shape: BoxShape.circle,
                          borderWidth: 1,
                          borderColor: Colors.white.withOpacity(0.1),
                          blur: 20,
                          child: const Center(
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),


                      const SizedBox(width: 12),
                      // Rectangular Title Box
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GlassContainer.frostedGlass(
                              height: 50,
                              width: constraints.maxWidth,
                              borderRadius: BorderRadius.circular(30),
                              borderWidth: 1,
                              borderColor: Colors.white.withOpacity(0.1),
                              blur: 20,
                              child: Center(
                                child: Text(
                                  _getTitle(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTitle() {
    switch (widget.movieType) {
      case MovieType.trending:
        return 'Trending';
      case MovieType.popular:
        return 'Popular';
      case MovieType.topRated:
        return 'Top Rated';
      case MovieType.nowPlaying:
        return 'Now Playing';
      case MovieType.upcoming:
        return 'Upcoming';
      case MovieType.similar:
        return 'Similar';
    }
  }

  List<MovieResults> _getMovies(MovieViewModel viewModel) {
    switch (widget.movieType) {
      case MovieType.trending:
        return viewModel.trendingMovies;
      case MovieType.popular:
        return viewModel.popularMovies;
      case MovieType.topRated:
        return viewModel.topRatedMovies;
      case MovieType.nowPlaying:
        return viewModel.nowPlayingMovies;
      case MovieType.upcoming:
        return viewModel.upcomingMovies;
      case MovieType.similar:
        return [];
    }
  }
}
