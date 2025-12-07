import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:framed_v2/providers.dart';
import 'package:framed_v2/ui/main_screen.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  putLumberdashToWork(withClients: [ColorizeLumberdash()]);

  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});
  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router.config(),
      title: "Framed",
      debugShowCheckedModeBanner: false,
      theme: createTheme(),
    );
  }
}
