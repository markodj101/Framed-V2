import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';


import 'dart:ui';

const delayTime = 1000 * 10;
const animationTime = 1000;

class HomeScreenImage extends ConsumerStatefulWidget {
  final MovieViewModel movieViewModel;
  final OnMovieTap onMovieTap;
  HomeScreenImage({
    required this.movieViewModel,
    required this.onMovieTap,
    super.key,
  });

  @override
  ConsumerState<HomeScreenImage> createState() => _HomeScreenImageState();
}

class _HomeScreenImageState extends ConsumerState<HomeScreenImage> {
  int _currentIndex = 0;
  double _playAnimTarget = 0;
  double _detailsAnimTarget = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final movies = widget.movieViewModel.nowPlayingMovies;
    if (movies.isEmpty) return const SizedBox();

    final currentMovie = movies[_currentIndex];

    // Get genre names
    final genres = currentMovie.genreIds
        .map((id) {
          final genre = widget.movieViewModel.movieGenres?.firstWhereOrNull(
            (g) => g.id == id,
          );
          return genre?.name;
        })
        .whereNotNull()
        .take(2)
        .join(', ');

    return SizedBox(
      height: screenHeight * 0.75, // Occupy most of the screen
      child: Stack(
        children: [
          // Background Swiper (Images Only)
          Positioned.fill(
            child: Swiper(
              autoplayDelay: delayTime,
              duration: animationTime,
              itemWidth: screenWidth,
              autoplay: true,
              itemCount: movies.length,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                final imageUrl = widget.movieViewModel.getImageUrl(
                  ImageSize.large,
                  movie.posterPath,
                );
                String uniqueHeroTag = '${movie.posterPath}swiper';

                return Hero(
                  tag: uniqueHeroTag,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.black),
                );
              },
            ),
          ),

          // Gradient Overlay (Static)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3), // Top darkening
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                    screenBackground.withOpacity(0.8), // Bottom darkening
                    screenBackground,
                  ],
                  stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                ),

              ),
            ),
          ),

          // Bottom Content (Dynamic but Static Position)
          // AnimatedSwitcher for smooth transition when movie changes
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Column(
                key: ValueKey<int>(
                  _currentIndex,
                ), // Trigger animation on index change
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeGrey.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'TRENDING #${_currentIndex + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(currentMovie.voteAverage.isFinite ? (currentMovie.voteAverage * 10).toInt() : 0)}% User Score',
                          style: const TextStyle(
                            color: matchGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    currentMovie.title,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metadata
                  Text(
                    '${currentMovie.releaseDate?.year ?? "N/A"} • $genres',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                   // Buttons
                   Row(
                     children: [
                       Expanded(
                         child: GestureDetector(
                           onTapDown: (_) => setState(() => _playAnimTarget = 1),
                           onTapUp: (_) => setState(() => _playAnimTarget = 0),
                           onTapCancel: () => setState(() => _playAnimTarget = 0),
                           onTap: () async {
                              final videos = await widget.movieViewModel.getMovieVideos(currentMovie.id);
                              if (videos != null && videos.results.isNotEmpty) {
                                final trailer = videos.results.firstWhereOrNull((v) => v.type == 'Trailer') ?? videos.results.first;
                                context.router.push(VideoPageRoute(movieVideo: trailer));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No trailer available')));
                              }
                           },
                           child: Container(
                             height: 52,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: const Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.play_arrow_rounded, color: Colors.black, size: 28),
                                 SizedBox(width: 4),
                                 Text(
                                   'Play',
                                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                                 ),
                               ],
                             ),
                           ).animate(target: _playAnimTarget)
                            .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95), duration: 100.ms, curve: Curves.easeOut),
                         ),
                       ),
                       const SizedBox(width: 12),
                       Expanded(
                         child: LayoutBuilder(
                           builder: (context, constraints) {
                             return GestureDetector(
                               onTapDown: (_) => setState(() => _detailsAnimTarget = 1),
                               onTapUp: (_) => setState(() => _detailsAnimTarget = 0),
                               onTapCancel: () => setState(() => _detailsAnimTarget = 0),
                               onTap: () {
                                 String uniqueHeroTag = '${currentMovie.posterPath}swiper';
                                 ref.read(heroTagProvider.notifier).state = uniqueHeroTag;
                                 widget.onMovieTap(currentMovie.id);
                               },
                               child: GlassContainer.frostedGlass(
                                 height: 52,
                                 width: constraints.maxWidth,
                                 borderRadius: BorderRadius.circular(30),
                                 borderWidth: 1.2,
                                 borderColor: Colors.white.withOpacity(0.1),
                                 blur: 20,
                                 child: const Center(
                                   child: Text(
                                     'Details',
                                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                                   ),
                                 ),
                               ).animate(target: _detailsAnimTarget)
                                .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95), duration: 100.ms, curve: Curves.easeOut),
                             );
                           }
                         ),
                       ),


                     ],
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
