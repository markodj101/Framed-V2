import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/screens/geners/genre_search_row.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:framed_v2/ui/screens/geners/sort_picker.dart';
import 'package:framed_v2/ui/theme/theme.dart';

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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 24.0),
                  child: Text(
                    "Find a Movie",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            GenreSearchRow((searchString) {}),
            ValueListenableBuilder<bool>(
              valueListenable: expandedNotifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return GenreSection(
                  genreStates: [],
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
            const Divider(),
            SortPicker(
              onSortSelected: (sorting) {
                // Handle sort selection here
              },
            ),
          ],
        ),
      ),
    );
  }
}
