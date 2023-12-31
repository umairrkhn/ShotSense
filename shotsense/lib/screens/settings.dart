import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          onPressed: () {
            signout(context);
          },
          child: const Text('Signout'),
        ),
      ),
    );
  }
}
