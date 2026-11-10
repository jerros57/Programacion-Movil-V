import 'package:ecotec_movie/models/movie.dart';
import 'package:flutter/material.dart';

class MovieSlider extends StatelessWidget {
  final List<Movie> movies;
  final String title;
  final bool isUpcoming;

  const MovieSlider({
    super.key,
    required this.movies,
    this.title = 'Cartelera',
    this.isUpcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      height: 315,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isUpcoming ? Colors.cyanAccent : Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (_, int index) {
                final movie = movies[index];
                final prefix = isUpcoming ? 'upcoming' : 'slider';
                movie.heroId = '$prefix-${movie.id}';

                return Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          'details',
                          arguments: movie,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // Proporción exacta 2:3 (130 x 195) para encuadre cinematográfico perfecto
                                Hero(
                                  tag: movie.heroId!,
                                  child: FadeInImage(
                                    placeholder: const AssetImage(
                                      'assets/no-image.jpeg',
                                    ),
                                    image: NetworkImage(movie.fullPosterImg),
                                    width: 130,
                                    height: 195,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Badge flotante de fecha o de calificación
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xBF000000),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isUpcoming
                                            ? Colors.cyanAccent.withValues(alpha: 0.5)
                                            : Colors.amber.withValues(alpha: 0.5),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isUpcoming
                                              ? Icons.calendar_month_rounded
                                              : Icons.star_rounded,
                                          color: isUpcoming
                                              ? Colors.cyanAccent
                                              : Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          isUpcoming
                                              ? movie.releaseDate.split('-').first
                                              : movie.voteAverage.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isUpcoming)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 3,
                                      ),
                                      color: const Color(0xCC000000),
                                      child: Text(
                                        movie.formattedReleaseDate,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
