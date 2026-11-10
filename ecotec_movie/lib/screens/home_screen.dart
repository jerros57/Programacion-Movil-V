import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotec_movie/providers/movies_provider.dart';
import 'package:ecotec_movie/screens/widgets/card_swiper.dart';
import 'package:ecotec_movie/screens/widgets/movie_slider.dart';
import 'package:ecotec_movie/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_movies_rounded, color: Colors.amber),
            const SizedBox(width: 8),
            const Text(
              'ECOTEC Cine',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 26),
            tooltip: 'Buscar películas',
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.amber,
        onRefresh: () async {
          await moviesProvider.refreshAll();
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
                      CircularProgressIndicator(color: Colors.amber),
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
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => provider.refreshAll(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              // Carrusel de tarjetas principales destacadas (Swiper)
              CardSwiper(movies: provider.onDisplayMovies),
              const SizedBox(height: 20),
              // Sección de Próximos Estrenos con fecha destacada
              if (provider.upcomingMovies.isNotEmpty) ...[
                MovieSlider(
                  movies: provider.upcomingMovies,
                  title: 'Próximos Estrenos',
                  isUpcoming: true,
                ),
                const SizedBox(height: 15),
              ],
              // Sección de Populares en Cartelera
              MovieSlider(
                movies: provider.onDisplayMovies,
                title: 'Populares en Cartelera',
                isUpcoming: false,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
    }
  }
}
