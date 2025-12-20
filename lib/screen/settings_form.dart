import 'package:firebase_practice/core/constants.dart';
import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/screen/loading.dart';
import 'package:firebase_practice/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> sugars = ['0', '1', '2', '3', '4'];
  String? currentSugar;
  String? currentName;
  int? currentStrength;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserModel?>(context);
    print('Provider UID: ${provider?.uid}');
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: provider?.uid).userData,
      builder: (context, snapshot) {
        // Even if no document exists, show the form with defaults
        UserData? userData = snapshot.data;

        // If still loading (connection state), show Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Update your brew settings',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: userData?.name ?? currentName,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
                onChanged: (value) => setState(() => currentName = value),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField(
                value: currentSugar ?? userData?.sugar ?? '0',
                decoration: textInputDecoration,
                items: sugars.map((sugar) {
                  return DropdownMenuItem(
                    value: sugar,
                    child: Text('$sugar sugars'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => currentSugar = value),
              ),
              SizedBox(height: 20.0),
              Slider(
                value: (currentStrength ?? userData?.strength ?? 100)
                    .toDouble(),
                onChanged: (value) =>
                    setState(() => currentStrength = value.round()),
                min: 100.0,
                max: 900.0,
                divisions: 8,
                activeColor:
                    Colors.brown[currentStrength ?? userData?.strength ?? 100],
                inactiveColor:
                    Colors.brown[currentStrength ?? userData?.strength ?? 100],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.pink[400]),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DatabaseService(uid: provider?.uid).updateUserData(
                      currentSugar ?? userData!.sugar!,
                      currentName ?? userData!.name!,
                      currentStrength ?? userData!.strength!,
                    );
                    Navigator.pop(context); // Close the bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Settings updated successfully!')),
                    );
                  }
                },
                child: Text('Update', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
