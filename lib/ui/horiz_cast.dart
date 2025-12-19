import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/ui/cast_image.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';

class HorizontalCast extends StatelessWidget {
  final List<MovieCast> castList;
  final MovieViewModel movieViewModel;
  const HorizontalCast({
    required this.castList,
    required this.movieViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
            child: Text(
              "Cast",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: 150, // Increased height for character name
            child: ListView.separated(

          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: castList.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),

          itemBuilder: (context, index) {
            var imageUrl = movieViewModel.getImageUrl(
              ImageSize.small,
              castList[index].profilePath,
            );
            return SizedBox(
              width: 90, // Slightly wider
              child: CastImage(
                imageUrl: imageUrl ?? '',
                name: castList[index].name,
                character: castList[index].character,
              ),
            );
          },
        ),
      ),
        ],
      ),
    );
  }

}
