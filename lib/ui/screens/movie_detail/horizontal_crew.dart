import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/ui/cast_image.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/utils.dart';

class HorizontalCrew extends StatelessWidget {
  final List<MovieCast> crewList;
  final MovieViewModel movieViewModel;
  const HorizontalCrew({
    required this.crewList,
    required this.movieViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Prioritize Crew roles: Director, Screenplay, Producer
    final sortedCrew = List<MovieCast>.from(crewList);
    sortedCrew.sort((a, b) {
      int getPriority(String? job) {
        if (job == 'Director') return 0;
        if (job == 'Screenplay' || job == 'Writer') return 1;
        if (job == 'Producer' || job == 'Executive Producer') return 2;
        return 3;
      }

      return getPriority(a.job).compareTo(getPriority(b.job));
    });

    return SliverToBoxAdapter(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
            child: Text(
              "Crew",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: sortedCrew.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                var imageUrl = movieViewModel.getImageUrl(
                  ImageSize.small,
                  sortedCrew[index].profilePath,
                );
                return SizedBox(
                  width: 90,
                  child: CastImage(
                    imageUrl: imageUrl ?? '',
                    name: sortedCrew[index].name,
                    character: sortedCrew[index].job,
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
