import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String movieAPIUrl = 'https://api.themoviedb.org/3/';

const trendingUrl = 'trending/movie/week';
const nowPlayingUrl = 'movie/now_playing';
const topRatedUrl = 'movie/top_rated';
const popularUrl = 'movie/popular';
const pageParameterName = 'page';
const movieIdParameterName = 'movie_id';
const apiKeyParameterName = 'api_key';
const movieUrl = 'movie';
const videosParameter = 'videos';
const creditsParameter = 'credits';

class MovieApiService {
  late final Dio dio;
  final String apiKey = dotenv.env['TMDB_KEY']!;
  final showDebugInfo = false;

  MovieApiService() {
    final String? key = dotenv.env['TMDB_KEY'];
    configureDio();
  }

  void configureDio() {
    final options = BaseOptions(
      baseUrl: movieAPIUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final queryParameters = options.queryParameters;
          queryParameters[apiKeyParameterName] = apiKey;
          return handler.next(options);
        },

        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },

        onError: (DioError error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
    if (showDebugInfo) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          error: true,
          request: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }

  Future<Response> getTrending([int page = 1]) async {
    final response = await dio.get(
      trendingUrl,
      queryParameters: {pageParameterName: page},
    );
    return response;
  }

  Future<Response> getMovieVideos(int movieId) async {
    return dio.get('$movieUrl/$movieId/$videosParameter');
  }

  Future<Response> getMovieCredits(int movieId) async {
    return dio.get('$movieUrl/$movieId/$creditsParameter');
  }

  Future<Response> getNowPlaying([int page = 1]) async {
    final response = await dio.get(
      nowPlayingUrl,
      queryParameters: {pageParameterName: page},
    );
    return response;
  }

  Future<Response> getPopular([int page = 1]) async {
    final response = await dio.get(
      popularUrl,
      queryParameters: {pageParameterName: page},
    );
    return response;
  }

  Future<Response> getMovieDetails(int movieId) async {
    return dio.get('$movieUrl/$movieId');
  }

  Future<Response> getTopRated([int page = 1]) async {
    final response = await dio.get(
      topRatedUrl,
      queryParameters: {pageParameterName: page},
    );
    return response;
  }
}
