import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/authServices.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userAddress = '';
  final auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100,),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                      color: Colors.grey
                  ),
                  child: const Center(child: Icon(Icons.person, size: 50, color: Color(0xFF222222),),),
                ),
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(user.displayName!, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            )),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            //   child: Text('Address', style: TextStyle(fontSize: 16),),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Expanded(
                child: Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user.displayName!,style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                            Text('  |  ${user.email}')
                          ],
                        ),
                
                        Text(userAddress)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24.0),
                child: GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Confirm Logout", style: TextStyle(fontWeight: FontWeight.w900),),
                            content:
                            const Text("Are you sure you want to Logout?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await auth.signout();
                                    // user.delete();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Okay",
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
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text('Log Out',
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
        ),
      ),
    );
  }
}
