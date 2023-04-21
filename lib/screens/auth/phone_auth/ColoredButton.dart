import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  const ColoredButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color(0xff1C6758),
          borderRadius: BorderRadius.circular(20)),
      child: const Text(
        "Next",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
