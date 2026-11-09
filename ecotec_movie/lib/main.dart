import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotec_movie/providers/movies_provider.dart';
import 'package:ecotec_movie/screens/details_screen.dart';
import 'package:ecotec_movie/screens/home_screen.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecotec AppMovie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        'details': (context) => const DetailsScreen(),
      },
    );
  }
}
