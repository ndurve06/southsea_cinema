import 'package:flutter/material.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  bool isOrderUpdated = false;
  bool isTicketBought = false;

  String _confirmationMessage = '';

  List<Booking> _bookings = [];
  bool _bookingsLoading = true;
  String _bookingsError = '';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();

      if (!mounted) {
        return;
      }

      setState(() {
        _bookings = bookings;
        _bookingsError = '';
        _bookingsLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _bookingsError = 'Could not load bookings: $error';
        _bookingsLoading = false;
      });
    }
  }

  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];

    for (final CartItem item in items) {
      parts.add('${item.quantity} x ${item.movie.name}');
    }

    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');

    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout() async {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    if (items.isEmpty) {
      return;
    }

    try {
      final int bookingNumber =
          await CinemaDatabase.instance.getNextBookingNumber();

      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: _buildSummary(items),
        total: cart.getTotal() + 4.00,
        date: _formatDate(DateTime.now()),
      );

      await CinemaDatabase.instance.insertBooking(booking);

      cart.clear();

      if (!mounted) {
        return;
      }

      setState(() {
        isTicketBought = true;
        _confirmationMessage =
            'Your booking has been confirmed! Booking number: $bookingNumber';
      });

      // Refresh the list below the basket so the new booking appears.
      await _loadBookings();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to complete your booking. Please try again.'),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLineItem(CartRepository cart, CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '${item.quantity} Tickets',
              style: const TextStyle(
                color: cinemaBrand,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.quantity} Standard'),
              Text(
                  '${item.movie.name}, Friday 25 December 2026 17:00, Southsea Cinema Room'),
            ],
          )),
          const SizedBox(width: 8),
          Text(
            '£${item.lineTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(width: 8),
          IconButton(
            style: IconButton.styleFrom(
                backgroundColor: cinemaBrand,
                foregroundColor: cinemaFontWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                )),
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                cart.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      color: cinemaSurface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cinemaBrand,
                  ),
                ),
                Text(
                  '£${booking.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              booking.summary,
              style: const TextStyle(color: cinemaFontWhite),
            ),
            const SizedBox(height: 4),
            Text(
              booking.date,
              style: const TextStyle(fontSize: 12, color: cinemaFontMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastBookings() {
    final Widget list;

    if (_bookingsLoading) {
      list = const Center(
        child: CircularProgressIndicator(color: cinemaBrand),
      );
    } else if (_bookingsError.isNotEmpty) {
      list = Text(
        _bookingsError,
        style: const TextStyle(color: cinemaFontWhite),
      );
    } else if (_bookings.isEmpty) {
      list = const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'No previous bookings found.',
          style: TextStyle(fontSize: 16, color: cinemaFontMuted),
        ),
      );
    } else {
      list = Column(
        children: [
          for (final Booking booking in _bookings) _buildBookingCard(booking),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text(
          'PAST BOOKINGS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        list,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();
    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          children: [
            _buildEmptyState(),
            const SizedBox(
              height: 12,
            ),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MY ORDER',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  'Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  'Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 48),
            ],
          ),
          for (final item in items)
            _buildLineItem(
              cart,
              item,
              items.indexOf(item),
            ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text(
                'Service Charge',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '£4.00',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Total Due',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '£${(cart.getTotal() + 4).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              PrimaryButton(
                  label: isOrderUpdated ? 'UPDATED' : 'UPDATE ORDER',
                  onPressed: () {
                    setState(() {
                      isOrderUpdated = true;
                    });
                  }),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryButton(
                    label: isTicketBought ? 'BOUGHT' : 'BUY TICKETS',
                    onPressed: _checkout,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(appTitle, style: cinemaHeaderStyle),
          backgroundColor: cinemaSurface,
          iconTheme: const IconThemeData(color: cinemaBrand),
          elevation: 0),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            _buildPastBookings(),
          ],
        ),
      ),
    );
  }
}