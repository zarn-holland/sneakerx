import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String imageUrl;
  const ImageDisplay({
    required this.imageUrl,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: imageUrl.isNotEmpty ? Center(child: Image.network(imageUrl, fit: BoxFit.fill, width: double.infinity,))
          : const Center(child: Text('No Image'),)
    );
  }
}
