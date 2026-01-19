import 'package:framed_v2/data/models/favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Favorites
  Future<List<Favorite>> getFavorites() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final data = response as List<dynamic>;
    return data.map((e) => Favorite.fromJson(e)).toList();
  }

  Future<void> saveFavorite(Favorite favorite) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('favorites').upsert({
      'user_id': userId,
      'movie_id': favorite.movieId,
      'title': favorite.title,
      'overview': favorite.overview,
      'image': favorite.image,
      'popularity': favorite.popularity,
      'release_date': favorite.releaseDate.toIso8601String(),
    });
  }

  Future<void> removeFavorite(int movieId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('favorites')
        .delete()
        .match({'user_id': userId, 'movie_id': movieId});
  }
  
  Stream<List<Favorite>> streamFavorites() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);
    
    return _client
      .from('favorites')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((data) => data.map((e) => Favorite.fromJson(e)).toList());
  }

  // Sync Logic
  Future<void> syncLocalFavoritesToCloud(List<Favorite> localFavorites) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    
    if (localFavorites.isEmpty) return;

    final List<Map<String, dynamic>> upsertData = localFavorites.map((f) => {
      'user_id': userId,
      'movie_id': f.movieId,
      'title': f.title,
      'overview': f.overview,
      'image': f.image,
      'popularity': f.popularity,
      'release_date': f.releaseDate.toIso8601String(),
    }).toList();

    await _client.from('favorites').upsert(upsertData);
  }
}
