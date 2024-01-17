import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/screens/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';

  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Flag to track loading state

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    await context.read<FirebaseAuthMethods>().loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );

    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  Future<void> googleSignIn() async {
    try {
      if (!mounted) {
        // Check if the widget is still mounted before proceeding
        return;
      }

      setState(() {
        isLoading = true;
      });

      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null || !mounted) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(googleAuthCredential);

      User? user = userCredential.user;

      if (user != null && mounted) {
        try {
          var userSnapshot = await _firestore.collection('users').doc(user.uid).get();
          if (!userSnapshot.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'email': user.email,
              'name': user.displayName,
              'photoUrl': user.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
            });
            Navigator.pop(context);
          }
        } catch (e) {
          // Handle Firestore write errors
          print('Error during Firestore write: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error during Firestore write: $e', style: const TextStyle(fontSize: 14, color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 38, 5, 116),
            ),
          );
        }
      } else {
        print('Error during sign in: User object is null or widget is not mounted.');
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during sign in: $e', style: const TextStyle(fontSize: 14, color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 38, 5, 116),
        ),
      );
      print('Error during sign in: $e');
    } finally {
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/ShotSense-logo.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  visible: false,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  visible: true,
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 38, 5, 116),),)
                  : ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 38, 5, 116),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SignInButton(
                Buttons.google,
                text: "Log In with Google",
                onPressed: googleSignIn,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? '),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
