import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;

  String? heroId;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.heroId,
  });

  /// Getter que devuelve la URL completa del póster en TMDB o una imagen alternativa de respaldo
  String get fullPosterImg {
    if (posterPath != null && posterPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  /// Alias de conveniencia para acceder a la URL completa del póster
  String get fullPosterUrl => fullPosterImg;

  /// Getter que devuelve el backdrop panorámico para la cabecera de detalles
  String get fullBackdropPath {
    if (backdropPath != null && backdropPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
    return fullPosterImg;
  }

  /// Retorna la fecha de estreno en formato legible (ej. "24 Nov 2026")
  String get formattedReleaseDate {
    if (releaseDate.isEmpty) return 'Próximamente';
    try {
      final parts = releaseDate.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = int.tryParse(parts[1]) ?? 1;
        final day = parts[2];
        const months = [
          'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
        ];
        final monthName = months[(month - 1).clamp(0, 11)];
        return '$day $monthName $year';
      }
    } catch (_) {}
    return releaseDate;
  }

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        overview: json['overview'] as String? ?? '',
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        releaseDate: json['release_date'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'release_date': releaseDate,
      };
}
