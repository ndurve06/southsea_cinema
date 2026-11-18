import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() {
    return _BookingsScreenState();
  }
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> _bookings = [];
  bool _loading = true;
  String _errorMessage = '';

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
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Could not load bookings: $error';
        _loading = false;
      });
    }
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
            Text(
              'Booking #${booking.bookingNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: cinemaBrand,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Summary: ${booking.summary}',
              style: const TextStyle(color: cinemaFontWhite),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${booking.date}',
              style: const TextStyle(color: cinemaFontMuted),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: £${booking.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: cinemaFontWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_loading) {
      content = const Center(
        child: CircularProgressIndicator(color: cinemaBrand),
      );
    } else if (_errorMessage.isNotEmpty) {
      content = Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: cinemaFontWhite),
        ),
      );
    } else if (_bookings.isEmpty) {
      content = const Center(
        child: Text(
          'No previous bookings found.',
          style: TextStyle(
            fontSize: 16,
            color: cinemaFontMuted,
          ),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(_bookings[index]);
        },
      );
    }

    return Scaffold(
      backgroundColor: cinemaBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Bookings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cinemaFontWhite,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
