import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/sliver_divider.dart';
// I'm assuming these imports based on your previous code
import 'package:framed_v2/ui/screens/geners/genre_search_row.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/vert_movie_list.dart';

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
                      return GenreSection(
                        genreStates: [
                          GenreState(genre: 'Action', isSelected: false),
                          GenreState(genre: 'Adventure', isSelected: false),
                          GenreState(genre: 'Crime', isSelected: false),
                          GenreState(genre: 'Mystery', isSelected: false),
                          GenreState(genre: 'War', isSelected: false),
                          GenreState(genre: 'Comedy', isSelected: false),
                          GenreState(genre: 'Romance', isSelected: false),
                          GenreState(genre: 'History', isSelected: false),
                          GenreState(genre: 'Music', isSelected: false),
                          GenreState(genre: 'Drama', isSelected: false),
                          GenreState(genre: 'Thriller', isSelected: false),
                          GenreState(genre: 'Family', isSelected: false),
                          GenreState(genre: 'Horror', isSelected: false),
                          GenreState(genre: 'Western', isSelected: false),
                          GenreState(
                            genre: 'Science Fiction',
                            isSelected: false,
                          ),
                          GenreState(genre: 'Animation', isSelected: false),
                          GenreState(genre: 'Documentation', isSelected: false),
                          GenreState(genre: 'TV Movie', isSelected: false),
                          GenreState(genre: 'Fantasy', isSelected: false),
                        ],
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
