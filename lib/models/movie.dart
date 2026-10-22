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

  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String name = json['name'] as String;
    final String year = json['year'] as String;
    final String ageRating = json['ageRating'] as String;
    final String description = json['description'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();
    final String imagePath = json['imagePath'] as String;

    return Movie(
      id: id,
      name: name,
      year: year,
      ageRating: ageRating,
      description: description,
      price: price,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'year': year,
      'ageRating': ageRating,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
    return data;
  }

  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  bool get isAdultOnly => ageRating == '18';
}
