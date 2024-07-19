import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarContent extends StatelessWidget {
  const AppbarContent({super.key, required this.name, required this.photo});

  final String name;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/girl.png',
            fit: BoxFit.cover,
            height: 45,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Alyna D\'suza',
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
