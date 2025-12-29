// // lib/core/constants/app_routes.dart
// import 'package:flutter/material.dart';
// import 'package:movies_app/screens/details_about_movie_screen.dart';
// import 'package:movies_app/screens/main_app.dart';
// import 'package:movies_app/screens/spiash_screen.dart';
// import 'package:movies_app/screens/watch_list_screen.dart';

// final Map<String, WidgetBuilder> routes = {
//   SpiashScreen.routeName: (context) => const SpiashScreen(),
//   MainApp.routeName: (context) => const MainApp(),
//   DetailsAboutMovieScreen.routeName: (context) {
//     final args = ModalRoute.of(context)?.settings.arguments;

//     int? movieId;
//     if (args is int) {
//       movieId = args;
//     } else if (args is Map && args['movieId'] is int) {
//       movieId = args['movieId'] as int;
//     }

//     if (movieId == null) {
//       // fallback nhẹ để khỏi crash (dev test), thích thì show 1 màn báo thiếu id
//       const fallbackId = 550; // Fight Club
//       return DetailsAboutMovieScreen(movieId: fallbackId);
//     }

//     return DetailsAboutMovieScreen(movieId: movieId);
//   },
//   WatchListScreen.routeName: (context) => const WatchListScreen(),
// };
