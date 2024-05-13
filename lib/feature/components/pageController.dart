import 'package:flutter/material.dart';
import 'package:sneakerx/feature/pages/LogIn.dart';
import 'package:sneakerx/feature/pages/Register.dart';

class TogglePages extends StatefulWidget {
  const TogglePages({super.key});

  @override
  State<TogglePages> createState() => _TogglePagesState();
}

class _TogglePagesState extends State<TogglePages> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(showSignUpPage: togglePages);
    } else {
      return Register(showLoginPage: togglePages);
    }
  }
}