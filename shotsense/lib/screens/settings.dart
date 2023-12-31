import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
<<<<<<< Updated upstream
import 'package:shotsense/widgets/custom_appBar.dart';
=======
import 'package:shotsense/widgets/bottom_navigation.dart';
>>>>>>> Stashed changes

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  void signout(BuildContext context) async {
    await context.read<FirebaseAuthMethods>().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
      appBar: CustomAppBar(title: "Settings"),
=======
    return BottomBarScreen(
        child: Scaffold(
      appBar: AppBar(title: const Text('Settings')),
>>>>>>> Stashed changes
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signout(context);
          },
          child: const Text('Signout'),
        ),
      ),
    ));
  }
}
