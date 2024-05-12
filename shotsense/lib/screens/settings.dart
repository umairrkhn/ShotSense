import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  void signout(BuildContext context) async {
    await context.read<FirebaseAuthMethods>().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Settings"),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 38, 5, 116),
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            signout(context);
          },
          child: const Text('Sign Out',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ),
    );
  }
}
