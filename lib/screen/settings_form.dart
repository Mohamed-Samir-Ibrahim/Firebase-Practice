import 'package:firebase_practice/core/constants.dart';
import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/screen/custom_button.dart';
import 'package:firebase_practice/screen/custom_text_form_field.dart';
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

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: provider?.uid).userData,
      builder: (context, snapshot) {
        // Show loading only on initial load
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Loading();
        }

        // Get data or use defaults for new users
        UserData? userData = snapshot.data;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  onChanged: (val) => setState(() => currentName = val),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  hintText: 'Name',
                  initialValue: userData?.name ?? '',
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  initialValue: currentSugar ?? userData?.sugar ?? '0',
                  decoration: textInputDecoration,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => currentSugar = val),
                ),
                const SizedBox(height: 20.0),
                Slider(
                  value: (currentStrength ?? userData?.strength ?? 100)
                      .toDouble(),
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  activeColor: Colors
                      .brown[currentStrength ?? userData?.strength ?? 100],
                  onChanged: (val) =>
                      setState(() => currentStrength = val.round()),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: provider?.uid).updateUserData(
                        currentSugar ?? userData?.sugar ?? '0',
                        currentName ?? userData?.name ?? 'New Crew User',
                        currentStrength ?? userData?.strength ?? 100,
                      );
                      Navigator.pop(context);
                    }
                  },
                  backgroundColor: WidgetStatePropertyAll(Colors.pink[400]),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
