class Movie {
  final String id;
  final String name;
  final String year;
  final String ageRating;
  final String description;
  final double price;
  final String imagePath;

  const Movie({
    required this.id,
    required this.name,
    required this.year,
    required this.ageRating,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  String get formattedPrice => '£${price.toStringAsFixed(2)}';
}
