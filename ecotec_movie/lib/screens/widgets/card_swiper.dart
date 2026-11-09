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
        height: screenSize.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: screenSize.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        itemHeight: screenSize.height * 0.45,
        itemWidth: screenSize.width * 0.7,
        layout: SwiperLayout.STACK,
        itemBuilder: (_, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                width: screenSize.width * 0.7,
                height: screenSize.height * 0.45,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/no-image.jpeg'),
                image: NetworkImage(movie.fullPosterImg),
              ),
            ),
          );
        },
      ),
    );
  }
}
