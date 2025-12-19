import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_configuration.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_detail.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/utils/utils.dart';


class DetailImage extends ConsumerStatefulWidget {
  final MovieConfiguration movieConfiguration;
  final MovieDetails details;
  final VoidCallback onTrailerPressed;

  const DetailImage({
    required this.movieConfiguration,
    required this.details,
    required this.onTrailerPressed,
    super.key,
  });
  @override
  ConsumerState<DetailImage> createState() => _DetailImageState();
}

class _DetailImageState extends ConsumerState<DetailImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = ref.watch(heroTagProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = getMovieDetailsImagePath(
      widget.details,
      widget.movieConfiguration,
    );
    final posterUrl = getSizedImageUrl(
      ImageSize.small,
      widget.movieConfiguration,
      widget.details.posterPath,
    );
    return SizedBox(
      height: 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Hero(
              tag: heroTag,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    )
                  : emptyWidget,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.3, 0.7, 1.0],
                colors: [
                  Colors.transparent,
                  screenBackground.withOpacity(0.5),
                  screenBackground,
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.details.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            widget.details.releaseDate.year.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Text('•', style: TextStyle(color: Colors.white70)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.details.genres.take(2).map((e) => e.name).join(', '),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.details.runtime} mins',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: InkWell(
                            onTap: widget.onTrailerPressed,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.play_arrow,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    'TRAILER',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (posterUrl != null)
                  Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );

  }
}

