import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/booking_item.dart';

const String _screeningDateTime = 'Friday 25 December 2026 17:00';

class BookingItemsList extends StatelessWidget {
  final List<BookingItem> items;

  const BookingItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final BookingItem item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${item.quantity} x ${item.filmName} at $_screeningDateTime - '
              'Unit price: £${item.unitPrice.toStringAsFixed(2)} - '
              'Line total: £${item.lineTotal.toStringAsFixed(2)}',
            ),
          ),
      ],
    );
  }
}
