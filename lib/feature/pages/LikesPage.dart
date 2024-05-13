import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/fireStoreServices.dart';
import '../components/ShoesList.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Likes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),),
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          //get all wishlist by userid
          stream: FireStoreServices.getUserFavorite(user.uid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //error handling
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //if there is no favorites, show message
              return const Center(
                child: Text(
                  'No Favorite(s) Yet',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              );
            }
            //if there is any we will show in list view
            else {
              final shoesList = snapshot.data!.docs;
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
    );
  }
}
