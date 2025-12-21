import 'package:firebase_practice/screen/custom_button.dart';
import 'package:firebase_practice/screen/custom_text_form_field.dart';
import 'package:firebase_practice/screen/loading.dart';
import 'package:firebase_practice/service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '';
  String password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                title: Text(
                  'Sign Up to Crew Brew',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    label: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.person, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      elevation: WidgetStatePropertyAll(0.0),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.brown[100],
              body: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  CustomTextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                    hintText: 'Email',
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) => value!.length < 6
                        ? 'Please enter password 6+ char long'
                        : null,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _authService
                            .registerWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Please supply a valid email';
                            loading = false;
                          });
                        }
                      }
                    },
                    backgroundColor: WidgetStatePropertyAll(Colors.brown[400]),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            ),
    );
  }
}
