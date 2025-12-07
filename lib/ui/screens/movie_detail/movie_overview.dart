import 'package:flutter/material.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_detail.dart';
import 'package:framed_v2/ui/theme/theme.dart';

class MovieOverview extends StatelessWidget {
  final MovieDetails details;
  const MovieOverview({super.key, required this.details});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 24),
      child: Text(details.overview, style: body1Regular),
    );
  }
}
