import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sneakerx/feature/components/pageController.dart';
import 'package:sneakerx/feature/pages/bottomNavigation.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //to keep user to login
        //this stream will return userState weather null or not, if null -> login page, not null -> home
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if connection not good? show circular indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //show error, sth went wrong
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error!'),
            );
            //check return null or not
          } else {
            // null -> login
            if (snapshot.data == null) {
              return const TogglePages();
            }
            //not null -> keep user to login -> home
            else {
              return const BottomNav();
            }
          }
        },
      ),
    );
  }
}