import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/booking_item.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.filmName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Unit price: £${item.unitPrice.toStringAsFixed(2)}'),
                Text('Line total: £${item.lineTotal.toStringAsFixed(2)}'),
              ],
            ),
          ),
      ],
    );
  }
}
