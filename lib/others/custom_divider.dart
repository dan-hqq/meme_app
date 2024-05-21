import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.0, 0.25, 0.75, 1.0],
        ),
      ),
    );
  }
}