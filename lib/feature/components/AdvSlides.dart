import 'package:flutter/material.dart';

class Suggestion extends StatelessWidget {
  final String imagePath;
  final Widget advPage;
  const Suggestion({
    required this.imagePath,
    required this.advPage,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => advPage)
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Image.asset(imagePath),
          ],
        ),
      ),
    );
  }
}