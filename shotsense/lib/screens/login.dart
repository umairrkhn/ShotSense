import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/screens/signup.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';

  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  visible: false,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  visible: true,
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 38, 5, 116),),)
                  : ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 38, 5, 116),
                  ),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white),
                  ),
                ),
                child: Text('Log In', style: TextStyle(fontSize: 14)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  Container(
                    width: 150,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? '),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Text(
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
