import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sneakerx/feature/pages/bottomNavigation.dart';

import '../auth/fireStoreServices.dart';
import '../model/shoes.dart';

class CheckOut extends StatefulWidget {
  final String id;
  final String size;
  final int price;
  const CheckOut({
    required this.id,
    required this.size,
    required this.price,
    super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final user = FirebaseAuth.instance.currentUser!;
  late DocumentSnapshot document;
  final int shippingFee = 50;
  int increment = 1;
  late int subtotal = 0;
  late int total = 0;
  String userAddress = '';

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userAddress = userData['address'] ?? ''; // Assuming address is a field in your 'users' collection
      });
    }
  }

  void _updateSubtotal() {
    subtotal = widget.price * increment;
  }
  void _updateTotal(){
    total = subtotal + shippingFee;
  }

  void _increment() {
    setState(() {
      increment++;
      _updateSubtotal();
      _updateTotal();
    });
  }

  void _decrement() {
    setState(() {
      if (increment > 1) {
        increment--;
        _updateSubtotal();
        _updateTotal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Check Out",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreServices.getAllShoes(),
        builder: (context, snapshot){
          //if we have data, get all the docs
          if(snapshot.hasData){
            List<QueryDocumentSnapshot> shoesList = snapshot.data!.docs.cast<QueryDocumentSnapshot>();
            // Find the recipe document with matching docID
            document = shoesList.firstWhere((doc) => doc.id == widget.id);
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

            _updateSubtotal();
            _updateTotal();
            _fetchUserData();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                          child: Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: imageUrl.isNotEmpty
                                ? Center(
                                child: Image.network(imageUrl,fit: BoxFit.fill, width: 150,)
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
                      const SizedBox(width: 10,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //name
                            Text(shoeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            Text(widget.size)//will modify later
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //quantity
                      //will modify later
                      Row(
                        children: [
                          const Text('Qty'),
                          IconButton(onPressed: _decrement, icon: const Icon(Icons.remove)),
                          Text(increment.toString()),
                          IconButton(onPressed: _increment, icon: const Icon(Icons.add))
                        ],
                      ),
                      Text('${double.parse(price.toString()).toStringAsFixed(2)} Bahts')
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SubTotal', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(height: 10,),
                          Text('Shipping', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(height: 15,),
                          Text('Total', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${double.parse(subtotal.toString()).toStringAsFixed(2)} Bahts', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 10,),
                          Text('${double.parse(shippingFee.toString()).toStringAsFixed(2)} Bahts', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 10,),
                          Text('${double.parse(total.toString()).toStringAsFixed(2)} Bahts', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24),)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0,),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: TextStyle(color: Colors.black, fontSize: 14)),
                          SizedBox(height: 10,),
                          Text('Email', style: TextStyle(color: Colors.black, fontSize: 14)),
                          SizedBox(height: 10,),
                          Text('Address', style: TextStyle(color: Colors.black, fontSize: 14))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(user.displayName!, style: const TextStyle(color: Colors.black, fontSize: 14)),
                          const SizedBox(height: 10,),
                          Text(user.email!, style: const TextStyle(color: Colors.black, fontSize: 14)),
                          const SizedBox(height: 10,),
                          Text(userAddress, style: const TextStyle(color: Colors.black, fontSize: 14),)
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        FireStoreServices.addToOrder(
                            userId: user.uid,
                            shoe: Shoes(
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
                            ),
                            total: total,
                            shoeSize: widget.size,
                            quantity: increment,
                            userName: user.displayName!,
                            userAddress: userAddress,
                            userEmail: user.email!);
                        FireStoreServices.removeFromCart(userId: user.uid, shoeId: docID);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context){
                              return const BottomNav();
                            }));
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.check, color: Colors.white,),
                                ),
                                content:
                                const Text("Your order is placed successfully!"),
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
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green,
                        ),
                        child: const Center(
                          child: Text('Place Order',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.white
                            ),),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          else{
            return const Center(child: CircularProgressIndicator(color: Colors.white,));
          }
        },
      ),
    );
  }
}
