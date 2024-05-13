

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sneakerx/feature/pages/CheckOut.dart';

import '../auth/fireStoreServices.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Bag',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),),
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          //get all wishlist by userid
          stream: FireStoreServices.getUserCart(user.uid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //error handling
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //if there is no favorites, show message
              return const Center(
                child: Text(
                  'Try to go shopping',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              );
            }
            //if there is any we will show in list view
            else {
              final items = snapshot.data!.docs;
              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  DocumentSnapshot document = items[index];//Get the document snapshot at the current index
                  String docID = document.id;

                  // Extract data from the document
                  Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

                  final imageUrl = data['urlImage'];
                  final shoeName = data['name'];
                  final size = data['preferred size'];
                  final price = data['price'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 18),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                              child: Container(
                                height: 130,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: imageUrl.isNotEmpty
                                    ? Center(
                                    child: Image.network(imageUrl,fit: BoxFit.fill, width: 130,)
                                )
                                    : const Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name
                                  Text(shoeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                                  size == null ? const Text('N/A', style: TextStyle(fontSize: 12),) : Text('Size - $size', style: const TextStyle(fontSize: 12),),
                                  Text('Price - $price', style: const TextStyle(fontSize: 12),),
                                  const SizedBox(height: 33,),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context){
                                                return CheckOut(id: docID, size: size, price: price,);
                                              }
                                          )
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text('Check Out',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: Colors.white
                                          ),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          IconButton(
                              onPressed: (){
                                FireStoreServices.removeFromCart(userId: user.uid, shoeId: docID);
                              },
                              icon: const Icon(Icons.cancel))
                        ],
                      ),
                    ),
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
