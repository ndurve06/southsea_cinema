import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
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
