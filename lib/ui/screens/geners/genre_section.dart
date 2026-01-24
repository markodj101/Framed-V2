import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/data/models/genre.dart';
import 'package:framed_v2/data/models/genre_state.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:glass_kit/glass_kit.dart';

typedef OnGenresSelected = void Function(List<GenreState>);
typedef OnGenresExpanded = void Function(bool);



// ... (imports remain mostly the same, add glass_kit if missing in original which it is)

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
          elevation: 0,
          expansionCallback: (int index, bool expanded) {
            setState(() {
              widget.onGenresExpanded(expanded);
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: widget.isExpanded,
              backgroundColor: Colors.transparent, // Transparent for glass effect
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Genres',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      // Red circle removed
                    ],
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: genreChips.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 12,
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
      final genre = widget.genreStates[index].genre;
      final isSelected = widget.genreStates[index].isSelected;
      
      return GestureDetector(
        onTap: () {
           setState(() {
            widget.genreStates[index] = GenreState(
              genre: genre,
              isSelected: !widget.genreStates[index].isSelected,
            );
            widget.onGenresSelected(widget.genreStates);
          });
        },
        child: GlassContainer.frostedGlass(
          height: 40,
          width: double.infinity,
          borderRadius: BorderRadius.circular(20),
          borderWidth: 1,
          borderColor: isSelected 
              ? Colors.white.withOpacity(0.5) 
              : Colors.white.withOpacity(0.1),
          blur: 15,
          gradient: LinearGradient(
              colors: isSelected
                  ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)]
                  : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          child: Center(
            child: Text(
              genre.name, 
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              )
            ),
          ),
        ),
      );
    }).toList();
  }

  List<GenreState> getSelectedGenres() {
    return widget.genreStates
        .where((genreState) => genreState.isSelected)
        .toList();
  }
}
