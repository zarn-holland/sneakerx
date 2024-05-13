import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sneakerx/feature/components/LikesButton.dart';
import 'package:sneakerx/feature/components/ShoeImageDisplay.dart';

import '../auth/fireStoreServices.dart';
import '../model/shoes.dart';
import 'CheckOut.dart';

class ShoeDetail extends StatefulWidget {
  final id;
  const ShoeDetail({
    required this.id,
    super.key});

  @override
  State<ShoeDetail> createState() => _ShoeDetailState();
}

class _ShoeDetailState extends State<ShoeDetail> {
  PageController _pageController = PageController();
  late DocumentSnapshot document;
  String selectedSize = '';

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Back",
          style: TextStyle(
              fontSize: 20,
              color: Colors.black,
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
            //find the recipe document with matching docID
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


            return Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            height: 300,
                            child: PageView(
                              controller: _pageController,
                              children: [
                                ImageDisplay(imageUrl: imageUrl,),
                                ImageDisplay(imageUrl: thumbNails[0],),
                                ImageDisplay(imageUrl: thumbNails[1],),
                                ImageDisplay(imageUrl: thumbNails[2],),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 3),
                                child: Text(
                                  shoeName,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 24),
                                child: Text('${price.toString()} Bahts',
                                    style:
                                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: LikesButton(
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
                                  thumbNails: thumbNails
                                )),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 15.0),
                        child: Expanded(
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(description, style: const TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text('Brand - $shoeBrand', style: const TextStyle(fontWeight: FontWeight.bold,),),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                        child: Divider(thickness: 2,),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 24, right: 24, bottom: 10,),
                        child: Text('Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ),
                      buildSizeSelection(sizes)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to the Cart!')),
                            );
                            FireStoreServices.addToCart(
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
                                    thumbNails: thumbNails
                                ),
                                shoeSize: selectedSize
                            );
                          },
                          child: Container(
                            width: 170,
                            height:50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green,
                            ),
                            child: const Center(
                              child: Text('Add to cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white
                                ),),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context){
                                      return CheckOut(id: docID, size: selectedSize, price : price);
                                    }
                                )
                            );
                          },
                          child: Container(
                            width: 170,
                            height:50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),

                            ),
                            child: const Center(
                              child: Text('Check Out',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.blue
                                ),),
                            ),
                          ),
                        ),
                      )
                    ],
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
  Widget buildSizeSelection(List<String> sizes) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: sizes.map((size) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSize = size; // Update the selected size
            });
          },
          child: Container(
            width: 80,
            height: 40,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: size == selectedSize ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: size == selectedSize ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}
