import 'package:firebase_practice/model/brew_model.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {
  const BrewTile({super.key, required this.brew});

  final BrewModel? brew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.only(top: 20.0, left: 6.0, right: 6.0, bottom: 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[brew?.strength ?? 900],
          ),
          title: Text(brew?.name ?? ''),
          subtitle: Text("There is ${brew?.sugar ?? ''} of sugar(s)"),
        ),
      ),
    );
  }
}
