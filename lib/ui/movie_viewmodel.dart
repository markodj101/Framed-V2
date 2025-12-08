import 'dart:math';

import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/data/models/genre.dart';
import 'package:framed_v2/data/models/movie.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/data/models/movie_response.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/network/movie_api_service.dart';
import 'package:framed_v2/ui/screens/movie_detail/movie_detail.dart';
import 'package:lumberdash/lumberdash.dart';

class MovieViewModel {
  final MovieApiService movieApiService;
  List<Genre>? movieGenres;
  Stream<List<Favorite>>? favoriteStream;
  List<Favorite> favoriteList = [];
  List<MovieResults> trendingMovies = [];
  List<MovieResults> topRatedMovies = [];
  List<MovieResults> popularMovies = [];
  List<MovieResults> nowPlayingMovies = [];

  MovieViewModel({required this.movieApiService});

  Future<MovieResponse?> getNowPlaying(int page) async {
    final response = await movieApiService.getNowPlaying(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      nowPlayingMovies = movieResponse.results;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getPopular(int page) async {
    final response = await movieApiService.getPopular(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      popularMovies = movieResponse.results;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getTopRated(int page) async {
    final response = await movieApiService.getTopRated(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      topRatedMovies = movieResponse.results;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getTrendingMovies(int page) async {
    final response = await movieApiService.getTrending(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      trendingMovies = movieResponse.results;
      print('Trending movies loaded');
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future setup() async {
    await Future.wait([setupConfiguration(), setupGenres()]);
  }

  Future setupConfiguration() async {}

  Future setupGenres() async {
    final response = await movieApiService.getGenres();
    if (response.statusCode == 200) {
      movieGenres = Genres.fromJson(response.data).genres;
    } else {
      logError(
        'Failed to load genres with error ${response.statusCode} and message ${response.statusMessage}',
      );
    }
  }

  Future<MovieResponse?> searchMoviesByGenre(String genres, int page) async {
    final response = await movieApiService.searchMoviesByGenre(genres, page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> searchMovies(String searchText, int page) async {
    final response = await movieApiService.searchMovies(searchText, page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Stream<List<Favorite>> streamFavorites() {
    favoriteList = [
      Favorite(
        movieId: 1,
        image: 'http://image.tmdb.org/t/p/w780/z1p34vh7dEOnLDmyCrlUVLuoDzd.jpg',
        favorite: false,
        title: 'Title',
        overview: 'Overview',
        popularity: 1.0,
        releaseDate: DateTime.now(),
      ),

      Favorite(
        movieId: 2,
        image: 'http://image.tmdb.org/t/p/w780/gKkl37BQuKTanygYQG1pyYgLVgf.jpg',
        favorite: false,
        title: 'Title',
        overview: 'Overview',
        popularity: 1.0,
        releaseDate: DateTime.now(),
      ),

      Favorite(
        movieId: 3,

        image: 'http://image.tmdb.org/t/p/w780/4xJd3uwtL1vCuZgEfEc8JXI9Uyx.jpg',

        favorite: false,

        title: 'Title',

        overview: 'Overview',

        popularity: 1.0,

        releaseDate: DateTime.now(),
      ),

      Favorite(
        movieId: 4,

        image: 'http://image.tmdb.org/t/p/w780/uuA01PTtPombRPvL9dvsBqOBJWm.jpg',

        favorite: false,

        title: 'Title',

        overview: 'Overview',

        popularity: 1.0,

        releaseDate: DateTime.now(),
      ),

      Favorite(
        movieId: 5,

        image: 'http://image.tmdb.org/t/p/w780/H6vke7zGiuLsz4v4RPeReb9rsv.jpg',

        favorite: false,

        title: 'Title',

        overview: 'Overview',

        popularity: 1.0,

        releaseDate: DateTime.now(),
      ),
    ];
    favoriteStream = Stream.value(favoriteList);
    return favoriteStream!;
  }

  void updateFavorite(Favorite favorite) {
    final index = favoriteList!.indexWhere(
      (favItem) => favItem.movieId == favorite.movieId,
    );
    if (index != -1) {
      favoriteList![index] = favorite;
    }
  }

  Future<MovieVideos?> getMovieVideos(int movieId) async {
    final response = await movieApiService.getMovieVideos(movieId);
    if (response.statusCode == 200) {
      try {
        return MovieVideos.fromJson(response.data);
      } catch (e) {
        logError('Failed to parse movie videos with error: $e');
        return null;
      }
    } else {
      logError(
        'Failed to load movie videos with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieCredits?> getMovieCredits(int movieId) async {
    final response = await movieApiService.getMovieCredits(movieId);
    if (response.statusCode == 200) {
      try {
        return MovieCredits.fromJson(response.data);
      } catch (e) {
        logError('Failed to parse movie credits with error: $e');
        return null;
      }
    } else {
      logError(
        'Failed to load movie credits with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieDetails?> getMovieDetails(int movieId) async {
    final response = await movieApiService.getMovieDetails(movieId);
    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        return MovieDetails.fromJson(response.data);
      } catch (e) {
        logError('Failed to parse movie details with error: $e');
        return null;
      }
    } else {
      logError(
        'Failed to load movie details with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }
}
