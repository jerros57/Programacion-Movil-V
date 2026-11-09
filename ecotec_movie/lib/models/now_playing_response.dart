import 'dart:convert';

import 'package:ecotec_movie/models/movie.dart';

class NowPlayingResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  NowPlayingResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory NowPlayingResponse.fromRawJson(String str) =>
      NowPlayingResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) =>
      NowPlayingResponse(
        page: json['page'] as int,
        results: List<Movie>.from(
          (json['results'] as List<dynamic>).map(
            (x) => Movie.fromJson(x as Map<String, dynamic>),
          ),
        ),
        totalPages: json['total_pages'] as int,
        totalResults: json['total_results'] as int,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'results': List<dynamic>.from(results.map((x) => x.toJson())),
        'total_pages': totalPages,
        'total_results': totalResults,
      };
}

