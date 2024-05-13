import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sneakerx/feature/components/AdvPage.dart';
import 'package:sneakerx/feature/components/BrandCard.dart';
import 'package:sneakerx/feature/components/ShoesList.dart';
import 'package:sneakerx/feature/pages/ViewAll.dart';
import 'package:sneakerx/feature/pages/bottomNavigation.dart';

import '../auth/fireStoreServices.dart';
import '../components/AdvSlides.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  PageController _pageController = PageController();
  String _searchQuery = '';

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF222222),
              height: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //app name
                  const Row(
                    children: [
                      Text('Sneaker', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                      Text('X', style: TextStyle(color: Colors.red,fontSize: 26, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  const SizedBox(height: 2,),
                  //search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      hintText: 'Search Products',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: const Icon(Icons.search, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            //brand logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                child: const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      BrandCard(brandImage: 'images/nikeLogo.png', brand: 'NIKE',),
                      SizedBox(width: 20,),
                      BrandCard(brandImage: 'images/adidasLogo.png', brand: 'Adidas',),
                      SizedBox(width: 20,),
                      BrandCard(brandImage: 'images/nbLogo.png', brand: 'New Balance',),
                      SizedBox(width: 20,),
                      BrandCard(brandImage: 'images/pumaLogo.png', brand: 'Puma',),
                      SizedBox(width: 20,),
                      BrandCard(brandImage: 'images/sketcherLogo.png', brand: 'Sketcher',),
                    ],
                  ),
                ),
              ),
            ),
            //suggestion
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                height: 155,
                child: PageView(
                  controller: _pageController,
                  children: const [
                    Suggestion(imagePath: 'images/slide.png', advPage: BottomNav(),),
                    Suggestion(imagePath: 'images/arrival.png', advPage: AdvPage(title: 'New Arrivals', adv: 'isArrival'),),
                    Suggestion(imagePath: 'images/best.png', advPage: AdvPage(title: 'Best Seller', adv: 'isBest'),),
                  ],
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const ScrollingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blueAccent,
                dotHeight: 11,
                dotWidth: 11
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 24, right: 24, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trending Sneakers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return const ViewAll();
                        })
                      );
                    },
                    child: const Text('View All',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue)),
                  )
                ],
              ),
            ),
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

                    //filter shoes based on search query with name
                    List filteredShoes = shoesList.where((shoe) {
                      String name = shoe['name'].toLowerCase();
                      String query = _searchQuery.toLowerCase();
                      return name.contains(query);
                    }).toList();

                    if (filteredShoes.isEmpty) {
                      return const Center(
                        child: Text('No Shoe(s) Found',
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: filteredShoes.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 1,
                        childAspectRatio: 1 /1.3,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = filteredShoes[index];
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
      ),
    );
  }
}


