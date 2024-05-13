import 'package:flutter/material.dart';

import '../auth/authServices.dart';
import '../auth/validate.dart';
import '../components/CustomTextField.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  final VoidCallback showLoginPage;
  Register({required this.showLoginPage, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();

  var isLoading = false;
  String email = '';
  String password = '';
  String name = '';
  String address = '';

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
  }

  Future<void> _signup() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show CircularProgressIndicator
      });

      try {
        _key.currentState!.save();
        // Perform signup
        await _auth.createUserWithEmailAndPassword(_email.text.trim(),
            _password.text.trim(), _name.text.trim(), _address.text.trim(),context);

        // No need for navigation here, it's handled elsewhere
      } catch (e) {
        // Handle signup errors
        print('Signup error: $e');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          isLoading = false; // Hide CircularProgressIndicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
          children:[ SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Form(
                    key: _key,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              'Create An Account and become a Hype Beast!', textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CustomTextField(
                            key: const ValueKey('name'),
                            hint: "Enter Name",
                            label: "Name",
                            controller: _name,
                            validate: Validate.validateName,
                            onSaved: (value) {
                              setState(() {
                                name = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            key: const ValueKey('email'),
                            hint: "Enter Address",
                            label: "Address",
                            controller: _address,
                            validate: Validate.validateAddress,
                            onSaved: (value) {
                              setState(() {
                                 address = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            key: const ValueKey('address'),
                            hint: "Enter Email",
                            label: "Email",
                            controller: _email,
                            validate: Validate.validateEmail,
                            onSaved: (value) {
                              setState(() {
                                email = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            key: const ValueKey('password'),
                            hint: "Enter Password",
                            label: "Password",
                            isPassword: true,
                            controller: _password,
                            validate: Validate.validatePassword,
                            onSaved: (value) {
                              setState(() {
                                password = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: GestureDetector(
                        onTap: _signup,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green,
                          ),
                          child: const Center(
                            child: Text('Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      ),
                    ),
                          const SizedBox(
                            height: 30,
                          ),
                          //option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an Account? "),
                              GestureDetector(
                                onTap: widget.showLoginPage,
                                child: const Text(
                                  'LogIn',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                          // const Spacer(),
                          //rules and policy
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ]
      ),
    );
  }

}
