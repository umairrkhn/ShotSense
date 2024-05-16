import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Object? _userData;
  final TextEditingController sessionName = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Object getUserData() async {
    _firestore
        .collection("users")
        .doc(context.read<FirebaseAuthMethods>().user.uid)
        .get();

    return _userData;
  }

  void signout(BuildContext context) async {
    await context.read<FirebaseAuthMethods>().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Settings"),
        body: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder(
                    stream: _firestore
                        .collection("users")
                        .doc(context.read<FirebaseAuthMethods>().user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: Builder(
                                builder: (context) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 30,
                                  );
                                },
                              ),
                              title: const Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              subtitle: Text(
                                (snapshot.data)?["displayName"],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromARGB(255, 125, 125, 125),
                                ),
                              ),
                              trailing: InkWell(
                                child: const Icon(
                                  Icons.edit,
                                  // color: Colors.white,
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Edit Username"),
                                          content: TextField(
                                            controller: sessionName,
                                            decoration: const InputDecoration(
                                              hintText: "Enter new username",
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _firestore
                                                    .collection("users")
                                                    .doc(context
                                                        .read<
                                                            FirebaseAuthMethods>()
                                                        .user
                                                        .uid)
                                                    .update({
                                                  "displayName":
                                                      sessionName.text,
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: Builder(
                                builder: (context) {
                                  return const Icon(
                                    Icons.email,
                                    size: 30,
                                  );
                                },
                              ),
                              title: const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              subtitle: Text(
                                (snapshot.data)?["email"],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromARGB(255, 125, 125, 125),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                const SizedBox(height: 20),
                Center(
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
              ],
            )));
  }
}
