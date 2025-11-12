import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/sliver_divider.dart';
import 'package:framed_v2/ui/screens/geners/genre_search_row.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/vert_movie_list.dart';

@RoutePage(name: 'GenreRoute')
class GenreScreen extends ConsumerStatefulWidget {
  const GenreScreen({super.key});

  @override
  ConsumerState<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends ConsumerState<GenreScreen> {
  final expandedNotifier = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: screenBackground,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 24),
                        child: Text(
                          "Find a Movie",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GenreSearchRow((searchString) {
                        // Implement search functionality here
                        print('Searching for: $searchString');
                      }),
                    ]),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: expandedNotifier,
                    builder: (BuildContext context, bool value, Widget? child) {
                      final genres = ref.read(genresProvider);
                      return GenreSection(
                        genreStates: genres,
                        isExpanded: value,
                        onGenresExpanded: (expanded) {
                          expandedNotifier.value = expanded;
                        },
                        onGenresSelected: (List<GenreState> states) {
                          // Handle genre selection here
                        },
                      );
                    },
                  ),
                  const SliverDivider(),
                  SortPicker(
                    useSliver: true,
                    onSortSelected: (sorting) {
                      // Handle sort selection here
                    },
                  ),
                  VerticalMovieList(movies: [], onMovieTap: (movieId) {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
