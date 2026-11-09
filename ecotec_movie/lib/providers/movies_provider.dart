import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecotec_movie/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '5bd32ef97e1568a8582ee4c212d5c25c';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];

  MoviesProvider() {
    debugPrint('Movies Provider Inicializado');
    getOnDisplayMovies();
  }

  Future<void> getOnDisplayMovies() async {
    final url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final nowPlayingResponse = NowPlayingResponse.fromRawJson(response.body);
        onDisplayMovie = nowPlayingResponse.results;
        notifyListeners();
      } else {
        debugPrint('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Excepción al obtener películas: $e');
    }
  }
}
