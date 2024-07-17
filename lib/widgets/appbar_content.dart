import 'package:flutter/material.dart';

class AppbarContent extends StatelessWidget {
  const AppbarContent({super.key});

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
        const Text(
          'Alyna D\'suza',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
