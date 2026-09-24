import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int tickets = 1;

  @override
  Widget build(BuildContext context) {
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
                  "Ted (2012) (15)",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                //Text(
                //"A wish comes true for John when his teddy bear, Ted, comes to life."),
                Row(
                  children: const [
                    Text("Southsea Cinema Room"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Text("Friday 25 December 2026, 18:00 - ends at 19:14")
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: const [
                    Text("Please note that Discounts / Membership Benefits "),
                    Text("will be applied once you have selected your tickets")
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [Text("Select Quantities (Upto 5 in total)")],
                ),
                const SizedBox(height: 32),
                Row(
                  children: const [
                    Text("Tickets"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    DropdownMenu<int>(
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
                    ),
                    const Text("Adult (£7.50)"),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () =>
                      print('$tickets ticket(s) added to your order'),
                  child: Text("ADD TO ORDER"),
                )
              ],
            )));
  }
}
