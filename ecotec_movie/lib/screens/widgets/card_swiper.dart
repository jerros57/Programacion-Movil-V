import 'package:card_swiper/card_swiper.dart';
import 'package:ecotec_movie/models/movie.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  final Size? size;

  const CardSwiper({
    super.key,
    required this.movies,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = size ?? MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 380,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    // Proporción exacta 2:3 para el encuadre perfecto del póster cinematográfico (TMDB 500x750)
    final double itemHeight = (screenSize.height * 0.47).clamp(320.0, 420.0);
    final double itemWidth = itemHeight * (2 / 3);

    return SizedBox(
      width: double.infinity,
      height: itemHeight + 30,
      child: Swiper(
        itemCount: movies.length,
        itemHeight: itemHeight,
        itemWidth: itemWidth,
        layout: SwiperLayout.STACK,
        itemBuilder: (_, index) {
          final movie = movies[index];
          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x8C000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: movie.heroId!,
                      child: FadeInImage(
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage('assets/no-image.jpeg'),
                        image: NetworkImage(movie.fullPosterImg),
                      ),
                    ),
                    // Degradado inferior con título y fecha de estreno
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Color(0xB3000000),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.6, 1.0],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  movie.formattedReleaseDate,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Badge de calificación flotante
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xBF000000),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x99FFC107),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
