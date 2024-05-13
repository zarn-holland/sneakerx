import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/fireStoreServices.dart';
import '../components/ShoesList.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({super.key});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "View All Shoes",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FireStoreServices.getAllShoes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.grey,));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No Shoes'));
                } else {
                  List shoesList = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: shoesList.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1 /1.3,
                    ),
                    itemBuilder: (context, index) {
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
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
