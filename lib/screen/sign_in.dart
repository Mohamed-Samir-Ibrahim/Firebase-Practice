import 'package:firebase_practice/screen/custom_text_form_field.dart';
import 'package:firebase_practice/screen/loading.dart';
import 'package:firebase_practice/service/auth_service.dart';
import 'package:firebase_practice/service/secure_storage_service.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = '';
  String password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool loading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await SecureStorageService.getDecryptedPassword(
        'saved_email',
      );
      final savedPassword = await SecureStorageService.getDecryptedPassword(
        'saved_password',
      );

      if (savedEmail != null && savedPassword != null) {
        setState(() {
          email = savedEmail;
          password = savedPassword;
          rememberMe = true;
        });
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

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
                  'Sign In to Crew Brew',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    label: Text(
                      'Sign Up',
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
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember me'),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        // Save credentials securely if remember me is checked
                        if (rememberMe) {
                          await SecureStorageService.storeEncryptedPassword(
                            'saved_email',
                            email,
                          );
                          await SecureStorageService.storeEncryptedPassword(
                            'saved_password',
                            password,
                          );
                        } else {
                          // Clear saved credentials
                          await SecureStorageService.storage.delete(
                            key: 'saved_email',
                          );
                          await SecureStorageService.storage.delete(
                            key: 'saved_password',
                          );
                        }
                        dynamic result = await _authService
                            .signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Please supply a valid credentials';
                            loading = false;
                          });
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.brown[400],
                      ),
                    ),
                    child: Text(
                      'Sign In',
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
