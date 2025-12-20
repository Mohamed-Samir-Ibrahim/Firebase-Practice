import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/screen/wrapper.dart';
import 'package:firebase_practice/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      catchError: (context, error) {
        // Log the error if necessary
        print('StreamProvider error: $error');
        // Return a fallback value in case of an error.
        // Since your type is UserModel?, you can return null.
        return null;
      },
      initialData: UserModel(),
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: Wrapper(),
      ),
    );
  }
}
