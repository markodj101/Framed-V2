import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:glass_kit/glass_kit.dart';

typedef OnSearch = void Function(String searchString);

class GenreSearchRow extends ConsumerStatefulWidget {
  final OnSearch onSearch;
  const GenreSearchRow(this.onSearch, {super.key});
  @override
  ConsumerState<GenreSearchRow> createState() => _GenreSearchRowState();
}

class _GenreSearchRowState extends ConsumerState<GenreSearchRow> {
  late TextEditingController movieTextController;
  final FocusNode textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    movieTextController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    movieTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GlassContainer.frostedGlass(
              height: 50,
              width: double.infinity,
              borderRadius: BorderRadius.circular(30),
              borderWidth: 1,
              borderColor: Colors.white.withOpacity(0.1),
              blur: 20,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                focusNode: textFocusNode,
                keyboardType: TextInputType.text,
                enableSuggestions: false,
                autofocus: false,
                onSubmitted: (value) {
                  widget.onSearch(value);
                },
                controller: movieTextController,
                autocorrect: false,
                decoration: InputDecoration(
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Search for movies, genres...',
                  hintStyle: body1Regular.copyWith(color: Colors.white.withOpacity(0.5)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      movieTextController.clear();
                    },
                    icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7)),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
