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
            child: Row(
              children: [
                Text(
                  "Ted (2012) (15)",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                    "A wish comes true for John when his teddy bear, Ted, comes to life."),
              ],
            )));
  }
}
