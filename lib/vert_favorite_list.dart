import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'favorite_row.dart';

class VerticalFavoriteList extends StatelessWidget {
  final List<Favorite> favorites;
  final MovieViewModel movieViewModel;
  final OnMovieTap onMovieTap;
  final OnFavoriteResultsTap onFavoriteResultsTap;
  const VerticalFavoriteList({
    super.key,
    required this.favorites,
    required this.movieViewModel,
    required this.onMovieTap,
    required this.onFavoriteResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return FavoriteRow(
          favorite: favorites[index],
          movieViewModel: movieViewModel,
          onMovieTap: (id) {
            onMovieTap(id);
          },
          onFavoriteResultsTap: (favorite) {
            onFavoriteResultsTap(favorite);
          },
        );
      }, childCount: favorites.length),
    );
  }
}
