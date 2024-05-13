import 'package:flutter/material.dart';
import 'package:sneakerx/feature/pages/ShoeDetail.dart';

class ShoesList extends StatefulWidget {
  final String id;
  final String name;
  final String brand;
  final String description;
  final String imageUrl;
  final bool isFavorite;
  final int price;
  final int quantity;
  final List<String> sizes;
  final List<String> thumbNails;
  const ShoesList({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    required this.price,
    required this.quantity,
    required this.sizes,
    required this.thumbNails,
    super.key});

  @override
  State<ShoesList> createState() => _ShoesListState();
}

class _ShoesListState extends State<ShoesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: GestureDetector(
        //navigate to recipe detail page based on recipe id
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>ShoeDetail(id: widget.id,),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(2, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                //image
                child: Container(
                  color: Colors.grey[200],
                  child: Image.network(widget.imageUrl, fit: BoxFit.fill,)
                ),
              ),
              // Name
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 8.0),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text('${widget.price.toString()} Bahts', style: const TextStyle(
                fontSize: 9,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
