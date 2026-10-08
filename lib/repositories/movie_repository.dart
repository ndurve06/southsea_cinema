import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return const [
      Movie(
          id: 'ted',
          name: 'Ted 2',
          year: '2012',
          ageRating: '15',
          description:
              'A wish comes true for John when his teddy bear, Ted, comes to life.',
          price: 7.99,
          imagePath: 'assets/images/ted.jpg'),
      Movie(
          id: 'despicable-me',
          name: 'Despicable Me',
          year: '2010',
          ageRating: 'PG',
          description:
              'Longtime villain Felonious Gru has his pride hurt when an unknown rival steals the Great Pyramid of Giza.',
          price: 7.99,
          imagePath: 'assets/images/despicable_me.jpg'),
    ];
  }
}
