import 'package:firebase_practice/model/brew_model.dart';
import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/screen/brew_list.dart';
import 'package:firebase_practice/screen/settings_form.dart';
import 'package:firebase_practice/service/auth_service.dart';
import 'package:firebase_practice/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    _showBottomSheet() {
      final user = Provider.of<UserModel?>(context, listen: false);
      return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Provider<UserModel?>.value(value: user, child: SettingsForm());
        },
      );
    }

    return StreamProvider<List<BrewModel>>.value(
      value: DatabaseService().brew,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.brown[400],
        appBar: AppBar(
          backgroundColor: Colors.brown[50],
          elevation: 0.0,
          title: Text('Crew Brew'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
              },
              child: Icon(Icons.logout),
            ),
            ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              child: Icon(Icons.settings),
            ),
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
