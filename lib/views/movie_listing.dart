import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
                Text(
                    "A wish comes true for John when his teddy bear, Ted, comes to life."),
                Row(
                  children: const [
                    Text("Southsea Cinema Room"),
                  ],
                ),
                Row(
                  children: const [
                    Text("Friday 25 December 2026, 18:00 - ends at 19:14")
                  ],
                ),
                Row(
                  children: const [
                    Text("Please note that Discounts / Membership Benefits "),
                    Text("will be applied once you have selected your tickets")
                  ],
                ),
                Row(
                  children: const [Text("Select Quantities (Upto 5 in total)")],
                ),
                Row(
                  children: const [Text("Tickets")],
                ),
                Row(
                  children: const [Text("Adult (£7.50)")],
                ),
                Row(
                  children: const [Text("ADD TO ORDER")],
                ),
              ],
            )));
  }
}
