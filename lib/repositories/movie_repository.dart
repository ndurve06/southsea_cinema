import 'package:southsea_cinema/models/movie.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MovieRepository {
  List<Movie>? _cachedMovies;

  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return cachedMovies;
    }

    return const [
      Movie(
          id: 'ted',
          name: 'TED 2',
          year: '2012',
          ageRating: '15',
          description:
              'A wish comes true for John when his teddy bear, Ted, comes to life.',
          price: 7.99,
          imagePath: 'assets/images/ted.jpg'),
      Movie(
          id: 'despicable-me',
          name: 'DESPICABLE ME',
          year: '2010',
          ageRating: 'PG',
          description:
              'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.',
          price: 7.99,
          imagePath: 'assets/images/despicable_me.jpg'),
      Movie(
          id: 'Shrek',
          name: 'SHREK',
          year: '2001',
          ageRating: 'U',
          description:
              'Shrek is an asocial ogre who loves the solitude of his swamp and enjoys fending off mobs and intruders.',
          price: 5.50,
          imagePath: 'assets/images/shrek.jpg'),
      Movie(
          id: 'interstellar',
          name: 'INTERSTELLAR',
          year: '2014',
          ageRating: '12',
          description:
              'In the near future, humanity faces extinction due to dust storms and widespread crop blights.',
          price: 8.99,
          imagePath: 'assets/images/interstellar.jpg'),
      Movie(
          id: 'wolf-of-wall-street',
          name: 'THE WOLF OF WALL STREET',
          year: '2013',
          ageRating: '18',
          description:
              'In 1987, twenty-two-year-old Jordan Belfort becomes a Wall Street stockbroker for L.F. Rothschild, employed under Mark Hanna.',
          price: 9.50,
          imagePath: 'assets/images/wolf_of_wall_street.jpg'),
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Movie> loadedMovies = [];

    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(itemMap);
      loadedMovies.add(movie);
    }

    _cachedMovies = loadedMovies;
    return loadedMovies;
  }

  List<Movie> getMoviesByAgeRating(String rating) {
    List<Movie> suitableMovies = [];
    for (final movie in getMovies()) {
      if (movie.ageRating == rating) {
        suitableMovies.add(movie);
      }
    }
    return suitableMovies;
  }

  List<Movie> getMoviesUnderPrice(double maxPrice) {
    List<Movie> suitableMovies = [];
    for (final movie in getMovies()) {
      if (movie.price < maxPrice) {
        suitableMovies.add(movie);
      }
    }
    return suitableMovies;
  }
}
