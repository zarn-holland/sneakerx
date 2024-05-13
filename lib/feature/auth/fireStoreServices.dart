import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/shoes.dart';

class FireStoreServices{
  //Save user to Firestore
  static Future<void> saveUser(String name, String email, String address, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'address': address,
    });
  }

  //Get all shoes from database
  static Stream<QuerySnapshot> getAllShoes() {
    final shoesStream =
    FirebaseFirestore.instance.collection('shoes').snapshots();
    return shoesStream;
  }

  //add a shoe to favorite
  static Future<void> addToFavorite({
    required String userId,
    required Shoes shoe,
    required bool update,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorite')
        .doc(shoe.id)
        .set({
      'id': shoe.id,
      'name': shoe.name,
      'brand': shoe.brand,
      'urlImage' : shoe.imageUrl,
      'description' : shoe.description,
      'price' : shoe.price,
      'isFavorite' : update,
      'availableSizes' : shoe.sizes,
      'thumbnailUrls' : shoe.thumbNails,
      'quantity' : shoe.quantity,
      'timestamp' : Timestamp.now()
    });
  }

  //remove shoe from favorite according to its id
  static Future<void> removeFromFavorite({
    required String userId,
    required String shoeId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorite')
        .doc(shoeId)
        .delete();
  }

  //get all the user's favorite list
  static Stream<QuerySnapshot> getUserFavorite(String userId) {
    final wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorite')
        .orderBy('timestamp',descending: true).snapshots();
    return wishlistStream;
  }

  //add a shoe to cart
  static Future<void> addToCart({
    required String userId,
    required Shoes shoe,
    required String shoeSize,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(shoe.id)
        .set({
      'id': shoe.id,
      'name': shoe.name,
      'brand': shoe.brand,
      'urlImage' : shoe.imageUrl,
      'price' : shoe.price,
      'preferred size' : shoeSize,
      'timestamp' : Timestamp.now()
    });
  }

  //get all shoes from cart
  static Stream<QuerySnapshot> getUserCart(String userId) {
    final wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .orderBy('timestamp',descending: true).snapshots();
    return wishlistStream;
  }
  //remove shoe from favorite according to its id
  static Future<void> removeFromCart({
    required String userId,
    required String shoeId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(shoeId)
        .delete();
  }

  //get new arrival or best seller from shoes collection
  static Stream<QuerySnapshot> getAllAdv(String field) {
    final shoesStream = FirebaseFirestore.instance
        .collection('shoes')
        .where(field , isEqualTo: true)
        .snapshots();
    return shoesStream;
  }

  //get shoes by its brand name
  static Stream<QuerySnapshot> getShoesByBrand(String brandName) {
    final shoesStream = FirebaseFirestore.instance
        .collection('shoes')
        .where('brand', isEqualTo: brandName)
        .snapshots();
    return shoesStream;
  }

  //add user orders to order collection
  static Future<void> addToOrder({
    required String userId,
    required Shoes shoe,
    required int total,
    required String shoeSize,
    required int quantity,
    required String userName,
    required String userAddress,
    required String userEmail
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc(shoe.id)
        .set({
      'id': shoe.id,
      'name': shoe.name,
      'brand': shoe.brand,
      'urlImage' : shoe.imageUrl,
      'price' : total,
      'preferred size' : shoeSize,
      'thumbnailUrls' : shoe.thumbNails,
      'quantity' : quantity,
      'receiver': userName,
      'address' : userAddress,
      'email' : userEmail,
      'timestamp' : Timestamp.now()
    });
  }

  //get all user's order
  static Stream<QuerySnapshot> getUserOrder(String userId) {
    final wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .orderBy('timestamp',descending: true).snapshots();
    return wishlistStream;
  }
}