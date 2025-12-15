import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_configuration.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_detail.dart';
import 'package:framed_v2/utils/utils.dart';

class DetailImage extends ConsumerStatefulWidget {
  final MovieConfiguration movieConfiguration;
  final MovieDetails details;
  const DetailImage({
    required this.movieConfiguration,
    required this.details,
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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: SizedBox(
        height: 200,

        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: _animation,
                child: Hero(
                  tag: heroTag,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.fitWidth,
                          height: 200,
                          width: screenWidth,
                        )
                      : emptyWidget,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.details.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
