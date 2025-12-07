import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/network/movie_api_service.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppRouter appRouter(AppRouterRef ref) => AppRouter();

final heroTagProvider = StateProvider<String>((ref) {
  return '';
});

@Riverpod(keepAlive: true)
Future<MovieViewModel> movieViewModel(MovieViewModelRef ref) async {
  final model = MovieViewModel(
    movieApiService: ref.read(movieApiServiceProvider),
  );
  await model.setup();
  return model;
}

@Riverpod(keepAlive: true)
MovieApiService movieApiService(MovieApiServiceRef ref) => MovieApiService();
