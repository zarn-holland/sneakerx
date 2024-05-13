import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ShoesList.dart';

class CustomDisplayList extends StatelessWidget {
  final String name;
  final fireStore;
  const CustomDisplayList({
    required this.name,
    required this.fireStore,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              const InkWell(
                child: Text('View all', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 ,color: Colors.blue),),
              )
            ],
          ),
        ),
        Container(
          height: 700,
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore.getAllShoes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.grey,));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No Shoes'));
              } else {
                List shoesList = snapshot.data!.docs;

                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      DocumentSnapshot document = shoesList[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      String shoeName = data['name'];
                      String shoeBrand = data['brand'];
                      String description = data['description'];
                      String imageUrl = data['urlImage'];
                      bool isFavorite = data['isFavorite'];
                      int price = data['price'];
                      int quantity = data['quantity'];
                      List<String> sizes = List<String>.from(data['availableSizes']);
                      List<String> thumbNails = List<String>.from(data['thumbnailUrls']);

                      return ShoesList(
                        id: docID,
                        name: shoeName,
                        brand: shoeBrand,
                        description: description,
                        imageUrl: imageUrl,
                        isFavorite: isFavorite,
                        price: price,
                        quantity: quantity,
                        sizes: sizes,
                        thumbNails: thumbNails,
                      );
                    }
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
