import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

//Run test cases in termial:
//flutter test test/movie_repository_test.dart

void main() {
  group('movie_repositories tests', () {
    final repository = MovieRepository();

    test('Returns at least 2 movies', () {
      final movies = repository.getMovies();
      expect(movies.length, greaterThanOrEqualTo(2));
    });

    test('Each movie had a unique id', () {
      final movies = repository.getMovies();
      final ids = movies.map((movie) => movie.id).toSet();

      expect(ids.length, movies.length);

      for (final movie in movies) {
        expect(movie.id.trim(), isNotEmpty);
        expect(movie.name.trim(), isNotEmpty);
        expect(movie.ageRating.trim(), isNotEmpty);
        expect(movie.price, greaterThan(0));
      }
    });

    test('getMovieById returns the correct movie', () {
      final movie = repository.getMovieById('despicable-me');
      //expect(movie, isNotNull);
      expect(movie!.name, 'DESPICABLE ME');
    });

    test('getMovieById returns null when id is missing', () {
      final movie = repository.getMovieById('unknown');
      expect(movie, isNull);
    });

    test('getMovieByAgeRating returns the correct movies', () {
      final movies = repository.getMoviesByAgeRating('PG');
      expect(movies, isNotEmpty);
      for (final movie in movies) {
        expect(movie.ageRating, 'PG');
      }
    });

    test('getMoviesUnderPrice returns movies under given price', () {
      const maxPrice = 8.00;
      final movies = repository.getMoviesUnderPrice(maxPrice);
      expect(movies, isNotEmpty);
      for (final movie in movies) {
        expect(movie.price, lessThan(maxPrice));
      }
    });
  });
}
