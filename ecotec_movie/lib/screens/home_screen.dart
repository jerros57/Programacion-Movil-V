import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotec_movie/providers/movies_provider.dart';
import 'package:ecotec_movie/screens/widgets/card_swiper.dart';
import 'package:ecotec_movie/screens/widgets/movie_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en Cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.signal_wifi_off_rounded, color: Colors.redAccent),
            tooltip: 'Simular error de red (QA)',
            onPressed: () => moviesProvider.simulateNetworkError(),
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await moviesProvider.getOnDisplayMovies();
        },
        child: _buildBody(context, moviesProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MoviesProvider provider) {
    switch (provider.state) {
      case MovieLoadingState.loading:
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Cargando cartelera...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

      case MovieLoadingState.error:
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 80,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage.isNotEmpty
                              ? provider.errorMessage
                              : 'Ocurrió un error al obtener las películas.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => provider.getOnDisplayMovies(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );

      case MovieLoadingState.success:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Tarjetas principales (Swiper)
              CardSwiper(movies: provider.onDisplayMovies),
              const SizedBox(height: 20),
              // Slider horizontal de películas
              MovieSlider(movies: provider.onDisplayMovies),
              const SizedBox(height: 20),
            ],
          ),
        );
    }
  }
}
