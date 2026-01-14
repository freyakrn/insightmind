import 'package:flutter/material.dart';
import 'package:insightmind_app/features/insightmind/presentation/pages/home_page.dart';
import '../features/insightmind/presentation/pages/dashboard_page.dart';
import '../features/insightmind/presentation/pages/history_page.dart';

class InsightMindApp extends StatelessWidget {
  const InsightMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsightMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),

      // ⬇️ halaman pertama
      initialRoute: '/home',

      // ⬇️ daftar route
      routes: {
        '/home': (context) => const HomePage (),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}
