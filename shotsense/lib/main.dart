import 'package:shotsense/firebase_options.dart';
import 'package:shotsense/screens/homepage.dart';
import 'package:shotsense/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Firebase Example';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const EmailPasswordLogin(),
        // routes: {
        //   EmailPasswordSignup.routeName: (context) =>
        //       const EmailPasswordSignup(),
        //   EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
        //   PhoneScreen.routeName: (context) => const PhoneScreen(),
        // },
      ),
    );
  }
}
