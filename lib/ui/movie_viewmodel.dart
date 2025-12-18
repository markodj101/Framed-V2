import 'dart:math';

import 'package:framed_v2/data/storage/hive_storage.dart';
import 'package:framed_v2/data/models/favorite.dart';
import 'package:framed_v2/data/models/genre.dart';
import 'package:framed_v2/data/models/movie_configuration.dart';
import 'package:framed_v2/data/models/movie_credits.dart';
import 'package:framed_v2/data/models/movie_details.dart';
import 'package:framed_v2/data/models/movie_response.dart';
import 'package:framed_v2/data/models/movie_results.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/network/movie_api_service.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/data/models/movie_type.dart';
import 'package:lumberdash/lumberdash.dart';

class MovieViewModel {
  final MovieApiService movieApiService;
  final HiveStorage storage;
  MovieConfiguration? movieConfiguration;
  List<Genre>? movieGenres;
  List<Favorite> favoriteList = [];
  List<MovieResults> trendingMovies = [];
  List<MovieResults> topRatedMovies = [];
  List<MovieResults> popularMovies = [];
  List<MovieResults> nowPlayingMovies = [];
  List<MovieResults> upcomingMovies = [];
  
  // Pagination tracking
  int _trendingPage = 1;
  int _popularPage = 1;
  int _topRatedPage = 1;
  int _nowPlayingPage = 1;
  int _upcomingPage = 1;

  MovieViewModel({required this.movieApiService, required this.storage});

  Future<MovieResponse?> getNowPlaying(int page, {bool append = false}) async {
    final response = await movieApiService.getNowPlaying(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      if (append) {
        nowPlayingMovies.addAll(movieResponse.results);
      } else {
        nowPlayingMovies = movieResponse.results;
      }
      _nowPlayingPage = page;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getPopular(int page, {bool append = false}) async {
    final response = await movieApiService.getPopular(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      if (append) {
        popularMovies.addAll(movieResponse.results);
      } else {
        popularMovies = movieResponse.results;
      }
      _popularPage = page;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getTopRated(int page, {bool append = false}) async {
    final response = await movieApiService.getTopRated(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      if (append) {
        topRatedMovies.addAll(movieResponse.results);
      } else {
        topRatedMovies = movieResponse.results;
      }
      _topRatedPage = page;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getTrendingMovies(int page, {bool append = false}) async {
    final response = await movieApiService.getTrending(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      if (append) {
        trendingMovies.addAll(movieResponse.results);
      } else {
        trendingMovies = movieResponse.results;
      }
      _trendingPage = page;
      print('Trending movies loaded');
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<MovieResponse?> getUpcomingMovies(int page, {bool append = false}) async {
    final response = await movieApiService.getUpcoming(page);
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(response.data);
      if (append) {
        upcomingMovies.addAll(movieResponse.results);
      } else {
        upcomingMovies = movieResponse.results;
      }
      _upcomingPage = page;
      return movieResponse;
    } else {
      logError(
        'Failed to load movies with error ${response.statusCode} and message ${response.statusMessage}',
      );
      return null;
    }
  }

  Future<void> loadMore(MovieType type) async {
    switch (type) {
      case MovieType.trending:
        await getTrendingMovies(_trendingPage + 1, append: true);
        break;
      case MovieType.popular:
        await getPopular(_popularPage + 1, append: true);
        break;
      case MovieType.topRated:
        await getTopRated(_topRatedPage + 1, append: true);
        break;
      case MovieType.nowPlaying:
        await getNowPlaying(_nowPlayingPage + 1, append: true);
        break;
      case MovieType.upcoming:
        await getUpcomingMovies(_upcomingPage + 1, append: true);
        break;
    }
  }

  Future setup() async {
    await Future.wait([setupConfiguration(), setupGenres()]);
  }

  Future setupConfiguration() async {
    final response = await movieApiService.getMovieConfiguration();
    if (response.statusCode == 200) {
      movieConfiguration = MovieConfiguration.fromJson(response.data);
    } else {
      logError(
        'Failed to load configuration with error ${response.statusCode} and message ${response.statusMessage}',
      );
    }
  }

  String? getImageUrl(ImageSize size, String? file) {
    if (file == null || movieConfiguration == null) {
      return null;
    }
    return getSizedImageUrl(size, movieConfiguration!, file);
  }

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

  Future saveFavorite(MovieDetails movieDetails) async {
    await storage.saveFavorite(
      Favorite(
        movieId: movieDetails.id,
        image: movieDetails.posterPath ?? '',
        favorite: true,
        title: movieDetails.title,
        overview: movieDetails.overview,
        popularity: movieDetails.popularity,
        releaseDate: movieDetails.releaseDate,
      ),
    );
  }

  Future<void> removeFavorite(int id) async {
    await storage.removeFavorite(id);
  }

  Future<List<Favorite>> getFavorites() async {
    return storage.getFavorites();
  }

  Stream<List<Favorite>> streamFavorites() {
    return storage.streamFavorites();
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
