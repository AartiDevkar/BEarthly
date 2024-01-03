import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onPressed;
  const SquareTile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onPressed, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Use the provided onPressed callback
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 40,
            ),
            const SizedBox(width: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
