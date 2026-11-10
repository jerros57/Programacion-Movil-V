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

class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;
  void Function(T value)? onValue;
  T? _value;
  Timer? _timer;

  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value as T));
  }
}

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '5bd32ef97e1568a8582ee4c212d5c25c';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  MovieLoadingState state = MovieLoadingState.loading;
  String errorMessage = '';
  List<Movie> onDisplayMovies = [];
  List<Movie> upcomingMovies = [];

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  /// Getter de compatibilidad con referencias existentes a onDisplayMovie
  List<Movie> get onDisplayMovie => onDisplayMovies;

  MoviesProvider() {
    debugPrint('Movies Provider Inicializado');
    getOnDisplayMovies();
    getUpcomingMovies();
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

  Future<void> getUpcomingMovies() async {
    final url = Uri.https(_baseUrl, '3/movie/upcoming', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final upcomingResponse =
            NowPlayingResponse.fromRawJson(response.body);
        upcomingMovies = upcomingResponse.results;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al cargar próximos lanzamientos: $e');
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      getOnDisplayMovies(),
      getUpcomingMovies(),
    ]);
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final searchResponse =
            NowPlayingResponse.fromRawJson(response.body);
        return searchResponse.results;
      }
    } catch (e) {
      debugPrint('Error en la búsqueda de películas: $e');
    }
    return [];
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
