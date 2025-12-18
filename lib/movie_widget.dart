import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/utils.dart';
import 'providers.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:framed_v2/data/models/movie.dart';

class MovieWidget extends ConsumerStatefulWidget {
  final int movieId;
  final String movieUrl;
  final OnMovieTap onMovieTap;
  final MovieType movieType;
  const MovieWidget({
    required this.movieId,
    required this.movieUrl,
    required this.onMovieTap,
    required this.movieType,
    super.key,
  });

  @override
  ConsumerState<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends ConsumerState<MovieWidget>
    with SingleTickerProviderStateMixin {
  bool animateImage = false;
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  );
  late String uniqueHeroTag;

  @override
  void initState() {
    super.initState();
    uniqueHeroTag = widget.movieUrl + widget.movieType.name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ref.read(heroTagProvider.notifier).state = uniqueHeroTag;
          animateImage = true;
          _controller.forward(from: 0);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 110,
          height: 160,
          child: Stack(
            children: [
              // Movie Image
              Hero(
                tag: uniqueHeroTag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Slightly less to fit inside border
                    child: CachedNetworkImage(
                      imageUrl: widget.movieUrl,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      height: 160,
                      width: 110,
                    ),
                  ),
                ),
              )
              .animate(
                autoPlay: false,
                controller: _controller,
                onComplete: (controller) {
                  if (animateImage) {
                    animateImage = false;
                    widget.onMovieTap(widget.movieId);
                  }
                },
              )
              .scaleXY(begin: 1.0, end: 1.05, duration: 150.ms, curve: Curves.easeOut)
              .then()
              .scaleXY(begin: 1.05, end: 1.0, duration: 150.ms, curve: Curves.easeIn),


            ],
          ),
        ),
      ),
    );
  }
}
