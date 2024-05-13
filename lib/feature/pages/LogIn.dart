import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../auth/authServices.dart';
import '../auth/validate.dart';
import '../components/CustomTextField.dart';

class LogIn extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const LogIn({required this.showSignUpPage, super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _auth = AuthService();

  var isLoading = false;
  String email = '';
  String password = '';

  final _email = TextEditingController();
  final _password = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _login() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show CircularProgressIndicator
      });

      try {
        _key.currentState!.save();
        //perform login
        await _auth.loginUserWithEmailAndPassword(
            _email.text.trim(), _password.text.trim(), context);
      } catch (e) {
        //handle login errors
        print('Login error: $e');
        //show an error to user
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login failed. Please try again.'),
          duration: Duration(seconds: 3),
        ));
      } finally {
        setState(() {
          isLoading = false; //Hide CircularProgressIndicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 250),
                  Form(
                    key: _key,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CustomTextField(
                            key: const ValueKey('email'),
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
                              password = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: GestureDetector(
                          onTap: _login,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green,
                            ),
                            child: const Center(
                              child: Text('Login',
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
                              height: 30
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don\'t have an Account? "),
                              GestureDetector(
                                onTap: widget.showSignUpPage,
                                child: const Text(
                                  'SignUp',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
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
              color: Colors.grey[600]!.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}