import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: cinemaBackground,
          foregroundColor: cinemaBrand,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          )),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
