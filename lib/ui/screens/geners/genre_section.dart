import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/theme/theme.dart';

class GenreState {
  final String genre;
  final bool isSelected;
  GenreState({required this.genre, required this.isSelected});
}

typedef OnGenresSelected = void Function(List<GenreState>);
typedef OnGenresExpanded = void Function(bool);

class GenreSection extends ConsumerStatefulWidget {
  final bool isExpanded;
  final List<GenreState> genreStates;
  final OnGenresExpanded onGenresExpanded;
  final OnGenresSelected onGenresSelected;

  const GenreSection({
    required this.isExpanded,
    required this.genreStates,
    required this.onGenresExpanded,
    required this.onGenresSelected,
    super.key,
  });

  @override
  ConsumerState<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends ConsumerState<GenreSection> {
  @override
  Widget build(BuildContext context) {
    final genreChips = getGenreChips();

    return SliverList(
      delegate: SliverChildListDelegate([
        ExpansionPanelList(
          expandIconColor: Colors.white,
          expansionCallback: (int index, bool expanded) {
            setState(() {
              widget.onGenresExpanded(expanded);
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: widget.isExpanded,
              backgroundColor: screenBackground,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Genres',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(width: 8.0),

                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            totalSelected().toString(),
                            style: verySmallText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: genreChips.length,

                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return genreChips[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  List<Widget> getGenreChips() {
    return widget.genreStates.mapIndexed((index, element) {
      final genreState = widget.genreStates[index];
      return FilterChip(
        backgroundColor: searchBarBackground,
        selectedColor: buttonGrey,
        label: Text(
          genreState.genre,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        selected: widget.genreStates[index].isSelected,
        onSelected: (selected) {
          setState(() {
            widget.genreStates[index] = GenreState(
              genre: genreState.genre,
              isSelected: !widget.genreStates[index].isSelected,
            );
            widget.onGenresSelected(widget.genreStates);
          });
        },
      );
    }).toList();
  }

  List<GenreState> getSelectedGenres() {
    return widget.genreStates
        .where((genreState) => genreState.isSelected)
        .toList();
  }

  int totalSelected() {
    return getSelectedGenres().length;
  }
}
