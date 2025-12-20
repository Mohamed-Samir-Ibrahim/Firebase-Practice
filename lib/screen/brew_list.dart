import 'package:firebase_practice/model/brew_model.dart';
import 'package:firebase_practice/screen/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatelessWidget {
  const BrewList({super.key});

  @override
  Widget build(BuildContext context) {
    final brew = Provider.of<List<BrewModel>>(context) ?? [];
    return ListView.builder(
      itemBuilder: (context, index) {
        return BrewTile(brew: brew[index]);
      },
      itemCount: brew.length,
    );
  }
}
