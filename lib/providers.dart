import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/network/movie_api_service.dart';
import 'package:framed_v2/ui/screens/geners/genre_section.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:framed_v2/router/app_routes.dart';
import 'package:framed_v2/ui/movie_viewmodel.dart';
import 'package:framed_v2/utils/prefs.dart';
import 'package:framed_v2/data/storage/hive_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:framed_v2/data/services/supabase_service.dart';
import 'package:framed_v2/data/services/auth_service.dart';
part 'providers.g.dart';

@Riverpod(keepAlive: true)
MovieApiService movieApiService(MovieApiServiceRef ref) => MovieApiService();

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPrefs(SharedPrefsRef ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
Future<Prefs> prefs(PrefsRef ref) async {
  final sharedPrefs = await ref.read(sharedPrefsProvider.future);
  return Prefs(sharedPrefs);
}

@Riverpod(keepAlive: true)
AppRouter appRouter(AppRouterRef ref) => AppRouter();

final heroTagProvider = StateProvider<String>((ref) {
  return '';
});

@Riverpod(keepAlive: true)
Future<MovieViewModel> movieViewModel(MovieViewModelRef ref) async {
  final storage = ref.read(hiveStorageProvider);
  final supabase = ref.read(supabaseServiceProvider);
  final auth = ref.read(authServiceProvider);
  final model = MovieViewModel(
    storage: storage,
    movieApiService: ref.read(movieApiServiceProvider),
    supabaseService: supabase,
    authService: auth,
  );
  await model.setup();
  return model;
}

@Riverpod(keepAlive: true)
HiveStorage hiveStorage(HiveStorageRef ref) {
  return HiveStorage();
}

@Riverpod(keepAlive: true)
SupabaseService supabaseService(SupabaseServiceRef ref) => SupabaseService();

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) => AuthService();
