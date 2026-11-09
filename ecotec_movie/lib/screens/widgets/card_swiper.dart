import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: 10,
        itemHeight: size.height * 0.7,
        itemWidth: size.width * 0.7,
        layout: SwiperLayout.STACK,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/no-image.jpeg'),
                image: const NetworkImage('https://picsum.photos/300/400'),
              ),
            ),
          );
        },
      ),
    );
  }
}
