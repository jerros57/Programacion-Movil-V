import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecotec_movie/models/models.dart';

enum MovieLoadingState {
  loading,
  success,
  error,
}

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '5bd32ef97e1568a8582ee4c212d5c25c';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  MovieLoadingState state = MovieLoadingState.loading;
  String errorMessage = '';
  List<Movie> onDisplayMovies = [];

  /// Getter de compatibilidad con referencias existentes a onDisplayMovie
  List<Movie> get onDisplayMovie => onDisplayMovies;

  MoviesProvider() {
    debugPrint('Movies Provider Inicializado');
    getOnDisplayMovies();
  }

  Future<void> getOnDisplayMovies() async {
    state = MovieLoadingState.loading;
    errorMessage = '';
    notifyListeners();

    final url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final nowPlayingResponse =
            NowPlayingResponse.fromRawJson(response.body);
        onDisplayMovies = nowPlayingResponse.results;
        state = MovieLoadingState.success;
      } else {
        state = MovieLoadingState.error;
        errorMessage =
            'Error al cargar películas. Código de respuesta HTTP: ${response.statusCode}';
      }
    } on SocketException {
      state = MovieLoadingState.error;
      errorMessage =
          'Error de red: No se pudo conectar al servidor. Verifica tu conexión a internet.';
    } on http.ClientException catch (e) {
      state = MovieLoadingState.error;
      errorMessage = 'Error en el cliente de conexión: ${e.message}';
    } on TimeoutException {
      state = MovieLoadingState.error;
      errorMessage =
          'Tiempo de espera agotado (10s). El servidor tardó demasiado en responder.';
    } catch (e) {
      state = MovieLoadingState.error;
      errorMessage = 'Ocurrió un error inesperado: $e';
    } finally {
      notifyListeners();
    }
  }
}
