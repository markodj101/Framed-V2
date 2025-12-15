import 'package:hive_flutter/hive_flutter.dart';
import 'package:framed_v2/data/models/favorite.dart';

class HiveStorage {
  static const String favoritesBoxName = 'favorites';

  Future<Box<Favorite>> get _favoritesBox async {
    if (Hive.isBoxOpen(favoritesBoxName)) {
      return Hive.box<Favorite>(favoritesBoxName);
    } else {
      return await Hive.openBox<Favorite>(favoritesBoxName);
    }
  }

  Future<void> saveFavorite(Favorite movie) async {
    print('HiveStorage: Saving favorite ${movie.movieId}');
    final box = await _favoritesBox;
    await box.put(movie.movieId, movie);
    print('HiveStorage: Saved. Box count: ${box.length}');
  }

  Future<void> removeFavorite(int movieId) async {
    print('HiveStorage: Removing favorite $movieId');
    final box = await _favoritesBox;
    await box.delete(movieId);
  }

  Future<bool> isFavorite(int movieId) async {
    final box = await _favoritesBox;
    return box.containsKey(movieId);
  }

  Future<List<Favorite>> getFavorites() async {
    print('HiveStorage: createFavorites list');
    final box = await _favoritesBox;
    print('HiveStorage: Box values count: ${box.values.length}');
    return box.values.toList();
  }

  Stream<List<Favorite>> streamFavorites() async* {
    final box = await _favoritesBox;
    // Emit initial value
    yield box.values.toList();
    // Watch for changes
    yield* box.watch().map((event) {
      return box.values.toList();
    });
  }
}
