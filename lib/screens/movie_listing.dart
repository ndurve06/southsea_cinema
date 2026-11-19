import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({
    super.key,
    required this.movie,
  });

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int tickets = 1;
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    final ticketDropdown = DropdownMenu<int>(
      initialSelection: 1,
      onSelected: (int? value) {
        if (value != null) {
          setState(() {
            tickets = value;
          });
        }
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 1, label: '1'),
        DropdownMenuEntry(value: 2, label: '2'),
        DropdownMenuEntry(value: 3, label: '3'),
        DropdownMenuEntry(value: 4, label: '4'),
        DropdownMenuEntry(value: 5, label: '5'),
      ],
    );

    final addButton = PrimaryButton(
      label: isAdded ? 'ADDED' : 'ADD TO ORDER',
      onPressed: () {
        if (isAdded) return;

        CartRepository.instance.addItem(CartItem(
          movie: widget.movie,
          quantity: tickets,
        ));

        setState(() {
          isAdded = true;
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.movie.name} (${widget.movie.year}) (${widget.movie.ageRating})',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  widget.movie.imagePath,
                  width: 110,
                  height: 165,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const Text("Southsea Cinema Room"),
                const SizedBox(height: 4),
                const Text("Friday 25 December 2026, 17:00"),
                const SizedBox(height: 32),
                Text(widget.movie.description),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Wide screens: everything on one line
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Tickets (${widget.movie.formattedPrice} each)"),
                          const SizedBox(width: 16),
                          ticketDropdown,
                          const SizedBox(width: 16),
                          addButton,
                        ],
                      );
                    } else {
                      // Narrow screens: label, dropdown, then button stacked
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tickets (${widget.movie.formattedPrice} each)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ticketDropdown,
                          const SizedBox(height: 16),
                          addButton,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}