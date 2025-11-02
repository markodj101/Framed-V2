import 'package:flutter/material.dart';
import 'package:framed_v2/ui/home/home_screen_image.dart';
import 'package:framed_v2/ui/home/horiz_movies.dart';
import 'package:framed_v2/ui/home/title_row.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/providers.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(movieImagesProvider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: screenBackground,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 24),
                    child: Text('Now Playing', style: largeTitle),
                  ),
                ),
                HomeScreenImage(),
                TitleRow(text: 'Trending', onMoreClicked: () {}),
                HorizontalMovies(movies: images),
                TitleRow(text: 'Popular', onMoreClicked: () {}),
                HorizontalMovies(movies: images),
                TitleRow(text: 'Top Rated', onMoreClicked: () {}),
                HorizontalMovies(movies: images),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
