import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shotsense/screens/sessionDetail.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotsense/widgets/small_card.dart';
import 'package:shotsense/classes/session.dart';
import 'package:shotsense/classes/ball.dart';
import 'package:intl/intl.dart';

class SessionPage extends StatefulWidget {
  SessionPage({Key? key}) : super(key: key);
  static const routeName = '/sessions';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController sessionName = TextEditingController();

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _previousSessionsExist = false;

  final CollectionReference _sessions =
      FirebaseFirestore.instance.collection('sessions');

  Stream<QuerySnapshot> getSessionsStream() {
    return FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Sessions"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Create New Session'),
                        content: TextField(
                          controller: widget.sessionName,
                          decoration: const InputDecoration(
                            hintText: 'Enter Session Name',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              widget.sessionName.clear();
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget._firestore.collection('sessions').add({
                                'name': widget.sessionName.text,
                                'userId': widget._auth.currentUser!.uid,
                                'createdAt': Timestamp.now(),
                                'completed': false,
                                'balls': [],
                              });
                              widget.sessionName.clear();
                              Navigator.pop(context);
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff221D55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_box_rounded,
                          size: 25, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text(
                        'Create New Session',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Current Session",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 79, 79, 79))),
              ),
              StreamBuilder(
                  stream: getSessionsStream(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    List<session> Sessions = snapshot.data!.docs.map((doc) {
                      List<ball> ballsList = List<ball>.from(
                          doc["balls"].map((item) => ball.fromJson(item)));
                      return session(
                          id: doc.id,
                          name: doc['name'],
                          userID: doc['userId'],
                          createdAt: doc['createdAt'],
                          completed: doc['completed'],
                          balls: ballsList);
                    }).toList();

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: Sessions.length >= 0
                                ? Sessions.map((Session) {
                                    return smallCard(
                                      name: Session.name,
                                      date: DateFormat('d MMM y')
                                          .format(Session.createdAt.toDate()),
                                      sessionId: Session.id,
                                    );
                                  }).toList()
                                : [
                                    Container(
                                      child: Text("No sesion Added"),
                                    )
                                  ],
                          ),
                          if (_previousSessionsExist == true)
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Previous Sessions",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 79, 79, 79))),
                            ),
                          Column(
                            children: Sessions.map((Session) {
                              if (Session.completed == true) {
                                _previousSessionsExist = true;
                                return smallCard(
                                  name: Session.name,
                                  date: DateFormat('d MMM y')
                                      .format(Session.createdAt.toDate()),
                                  sessionId: Session.id,
                                );
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ),
                        ]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
