import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/ui/cast_image.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';

class HorizontalCast extends ConsumerWidget {
  final List<MovieCast> castList;
  final MovieViewModel movieViewModel;
  const HorizontalCast({
    required this.castList,
    required this.movieViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100.0,
          mainAxisExtent: 100.0,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var imageUrl = movieViewModel.getImageUrl(
            ImageSize.small,
            castList[index].profilePath,
          );
          return imageUrl != null
              ? CastImage(imageUrl: imageUrl, name: castList[index].name)
              : emptyWidget;
        }, childCount: castList.length),
      ),
    );
  }
}
