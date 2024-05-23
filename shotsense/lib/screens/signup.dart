import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shotsense/widgets/custom_textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signup';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  Future<void> signUpUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (formKey.currentState?.validate() ?? false) {
        if (displayNameController.text.trim().isEmpty ||
            emailController.text.trim().isEmpty ||
            passwordController.text.trim().isEmpty ||
            repeatPasswordController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All fields are required',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
              backgroundColor: Color.fromARGB(255, 38, 5, 116),
            ),
          );
          return;
        }
      }

      if (passwordController.text.trim().length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 6 characters long',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 38, 5, 116),
          ),
        );
        return;
      }

      if (passwordController.text.trim() !=
          repeatPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 38, 5, 116),
          ),
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': displayNameController.text.trim(),
            'email': emailController.text.trim(),
            'uid': user.uid,
            'createdAt': DateTime.now(),
          });
          Navigator.pop(context);
        } catch (e) {
          // Handle Firestore write errors
          print('Error during Firestore write: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error during Firestore write: $e',
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 38, 5, 116),
            ),
          );
        }
      } else {
        print('Error during sign up: User object is null.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during sign up: $e',
              style: const TextStyle(fontSize: 14, color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 38, 5, 116),
        ),
      );
      print('Error during sign up: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> googleSignUp() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Trigger the Google Sign-In process
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User canceled the Google Sign-In process
        setState(() {
          isLoading = false;
        });
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(googleAuthCredential);

      User? user = userCredential.user;

      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': user.displayName,
            'email': user.email,
            'uid': user.uid,
            'createdAt': DateTime.now(),
          });
          Navigator.pop(context);
        } catch (e) {
          // Handle Firestore write errors
          print('Error during Firestore write: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error during Firestore write: $e',
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 38, 5, 116),
            ),
          );
        }
      } else {
        print('Error during sign up: User object is null.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during sign up: $e',
              style: const TextStyle(fontSize: 14, color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 38, 5, 116),
        ),
      );
      print('Error during sign up: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                    controller: displayNameController,
                    hintText: 'Name',
                    visible: false,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: repeatPasswordController,
                    hintText: 'Repeat Password',
                    visible: true,
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 38, 5, 116),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: signUpUser,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 38, 5, 116),
                          ),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white),
                          ),
                        ),
                        child: const Text('Sign Up',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
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
                    Text('OR',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                  text: 'Sign Up with Google',
                  onPressed: googleSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
