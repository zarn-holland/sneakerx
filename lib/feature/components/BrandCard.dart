import 'package:flutter/material.dart';
import 'package:sneakerx/feature/components/BrandPage.dart';

class BrandCard extends StatelessWidget {
  final String brandImage;
  final String brand;
  const BrandCard({
    required this.brandImage,
    required this.brand,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BrandPage(brand: brand,))
        );
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Image.asset(brandImage,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
