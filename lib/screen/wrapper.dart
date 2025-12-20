import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/screen/authenticate.dart';
import 'package:firebase_practice/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserModel?>(context);
    print('Provider UID: ${provider?.uid}');
    print(provider);
    return provider == null ? Authenticate() : Home();
  }
}
