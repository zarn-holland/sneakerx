import 'package:flutter/material.dart';
import 'package:sneakerx/feature/model/shoes.dart';

import '../auth/fireStoreServices.dart';

class LikesButton extends StatefulWidget {
  final String userId;
  final Shoes shoe;

  const LikesButton({
    required this.userId,
    required this.shoe,
  });

  @override
  State<LikesButton> createState() => _LikesButtonState();
}

class _LikesButtonState extends State<LikesButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the recipe is in the user's wishlist
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    // Query the user's wishlist to see if the recipe exists there
    final querySnapshot =
    await FireStoreServices.getUserFavorite(widget.userId).first;
    final recipes = querySnapshot.docs;
    final isFavorite = recipes.any((doc) => doc.id == widget.shoe.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        if (_isFavorite) {
          FireStoreServices.addToFavorite(
            userId: widget.userId,
            shoe: widget.shoe,
            update: _isFavorite,
          );
        } else {
          FireStoreServices.removeFromFavorite(
            userId: widget.userId,
            shoeId: widget.shoe.id,
          );
        }
      },
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : null, size: 30,
      ),
    );
  }
}
