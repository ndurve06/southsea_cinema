class BookingItem {
  final int? id;
  final int? bookingId;
  final String filmId;
  final String filmName;
  final double unitPrice;
  final int quantity;

  const BookingItem({
    this.id,
    this.bookingId,
    required this.filmId,
    required this.filmName,
    required this.unitPrice,
    required this.quantity,
  });

  double get lineTotal => unitPrice * quantity;

  Map<String, Object?> toMapForBooking(int bookingId) {
    return <String, Object?>{
      'booking_id': bookingId,
      'film_id': filmId,
      'film_name': filmName,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }

  factory BookingItem.fromMap(Map<String, Object?> map) {
    final num unitPrice = map['unit_price'] as num;

    return BookingItem(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int,
      filmId: map['film_id'] as String,
      filmName: map['film_name'] as String,
      unitPrice: unitPrice.toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}
