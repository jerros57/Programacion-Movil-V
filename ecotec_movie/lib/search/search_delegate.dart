import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotec_movie/models/movie.dart';
import 'package:ecotec_movie/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  @override
  String get searchFieldLabel => 'Buscar películas...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141622),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return _buildEmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Escribe el nombre de una película',
        subtitle: 'Explora millones de títulos disponibles en TMDB.',
      );
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder<List<Movie>>(
      future: moviesProvider.searchMovies(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados para "$query"',
            subtitle: 'Intenta con otro título o revisa la ortografía.',
          );
        }

        final movies = snapshot.data!;
        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            color: Colors.white10,
            indent: 85,
          ),
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return _buildEmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Encuentra tus películas favoritas',
        subtitle: 'Busca por título o palabra clave en tiempo real.',
      );
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder<List<Movie>>(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin coincidencias para "$query"',
            subtitle: 'Prueba escribiendo otra palabra.',
          );
        }

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            color: Colors.white10,
            indent: 85,
          ),
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0x1AFFC107),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 70, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Hero(
        tag: movie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpeg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 55,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        movie.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            movie.voteAverage.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (movie.releaseDate.isNotEmpty) ...[
            const SizedBox(width: 10),
            Text(
              '•  ${movie.releaseDate.split('-').first}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
