import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:sneakerx/feature/auth/fireStoreServices.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

Future<User?> createUserWithEmailAndPassword(
    String email, String password, String name, String address,BuildContext context) async {
  try {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    //save to firebase
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    // ignore: deprecated_member_use
    await FirebaseAuth.instance.currentUser!.updateEmail(email);
    //save user information
    await FireStoreServices.saveUser(name, email, address, cred.user!.uid);

    return cred.user;
  } on FirebaseAuthException catch (e) {
    //if email is aldy registered
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'This email is already registered! Try again with another email.')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  }
  return null;
}

Future<User?> loginUserWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return cred.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user found with this email.')),
      );
    } else if (e.code == 'invalid-credential') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password. Please try again.')),
      );
    }
    // rethrow the exception if it's not one of the handled cases
    throw e;
  } catch (e) {
    // Handle other types of exceptions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: ${e.toString()}')),
    );
  }
  return null;
}

Future<void> signout() async {
  try {
    //logout
    await _auth.signOut();
  } catch (e) {
    log('Something went wrong!');
  }
}
}