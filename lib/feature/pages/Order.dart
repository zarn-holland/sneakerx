import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/fireStoreServices.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Order',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),),
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          //get all wishlist by userid
          stream: FireStoreServices.getUserOrder(user.uid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //error handling
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //if there is no favorites, show message
              return const Center(
                child: Text(
                  'There is no Order yet!',
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
                  final quantity = data['quantity'];
                  final receiver = data['receiver'];
                  final address = data['address'];
                  final email = data['email'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 340,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 18),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                                  child: Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: imageUrl.isNotEmpty
                                        ? Center(
                                        child: Image.network(imageUrl,fit: BoxFit.fill, width: 100,)
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
                                      const SizedBox(height: 10,),
                                      //name
                                      Text(shoeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                      size == null ? const Text('N/A', style: TextStyle(fontSize: 16),) : Text('Size - $size', style: const TextStyle(fontSize: 16),),
                                      Text('Quantity - $quantity', style: const TextStyle(fontSize: 16),),
                                      const SizedBox(height: 33,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 1,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$quantity item'),
                                Row(
                                  children: [
                                    const Text('Order Total : '),
                                    Text('$price Bahts', style: const TextStyle(color: Colors.red),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(thickness: 1,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Text('Ship to - $address', style: const TextStyle(color: Colors.green),),
                          ),
                          const Divider(thickness: 1,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Text('Receiver - $receiver',),
                          ),
                          const Divider(thickness: 1,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Confirm receipt after you\'ve checked', style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text('the received items and made payment', style: TextStyle(fontSize: 12, color: Colors.grey))
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 80,),
                                            content:
                                            const Text("Your order is processing......! Please wait for a while."),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(color: Colors.black),
                                                  )),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(12.0)
                                    ),
                                    child: const Center(
                                      child: Text('Order Received',style: TextStyle(color: Colors.white, fontSize: 12),),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
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
