import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/movie.dart';

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

    final addButton = ElevatedButton(
      onPressed: () {
        setState(() {
          isAdded = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      child: Text(isAdded ? "ADDED" : "ADD TO ORDER"),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle, style: cinemaHeaderStyle),
          backgroundColor: cinemaSurface,
          iconTheme: const IconThemeData(color: cinemaBrand),
          elevation: 0,
        ),
        drawer: const NavDrawer(),
        // body: const SizedBox.shrink(),
        body: Container(
            color: cinemaBackground,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.movie.name} (${widget.movie.year}) (${widget.movie.ageRating})',
                  style: TextStyle(
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
                Text("Southsea Cinema Room"),
                const SizedBox(height: 4),
                Row(
                  children: const [Text("Friday 25 December 2026, 17:00")],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Text(widget.movie.description)),
                  ],
                ),
                const SizedBox(height: 16),
                /*Row(
                  children: const [
                    Text(
                      "Please note that Discounts / Membership Benefits "
                      "will be applied once you have selected your tickets",
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [Text("Select Quantities (Upto 5 in total)")],
                ),
                const SizedBox(height: 32), */
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                                "Tickets (${widget.movie.formattedPrice} each)"),
                            SizedBox(width: 100),
                            ticketDropdown,
                            SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 16),
                        addButton,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                "Tickets (£${widget.movie.price.toStringAsFixed(2)} each)"),
                            const SizedBox(width: 30),
                            ticketDropdown,
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 16),
                        addButton,
                      ],
                    );
                  }
                })
              ],
            )));
  }
}
