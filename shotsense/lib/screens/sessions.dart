import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'package:shotsense/widgets/small_card.dart';
import 'package:shotsense/classes/session.dart';
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
  String _selectedSession = 'current';

  Stream<QuerySnapshot> getSessionsStream() {
    return FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: user!.uid)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSession = 'current';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: _selectedSession == 'current'
                            ? Color.fromARGB(255, 205, 32, 109)
                            : null,
                      ),
                      child: Text(
                        'Current Sessions',
                        style: TextStyle(
                          color: _selectedSession == 'current'
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSession = 'previous';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: _selectedSession == 'previous'
                            ? Color.fromARGB(255, 205, 32, 109)
                            : null,
                      ),
                      child: Text(
                        'Previous Sessions',
                        style: TextStyle(
                          color: _selectedSession == 'previous'
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
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
                      return session(
                        id: doc.id,
                        name: doc['name'],
                        userID: doc['userId'],
                        createdAt: doc['createdAt'],
                        completed: doc['completed'],
                      );
                    }).toList();

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Sessions.isNotEmpty)
                            (_selectedSession == 'current')
                                ? Column(
                                    children: Sessions.map((Session) {
                                      if (Session.completed == false) {
                                        return smallCard(
                                          name: Session.name,
                                          date: DateFormat('d MMM, y').format(
                                              Session.createdAt.toDate()),
                                          sessionId: Session.id,
                                        );
                                      } else {
                                        return Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                top: 30.0),
                                            child: const Text(
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                'No current playing session yet'));
                                      }
                                    }).toList(),
                                  )
                                : Column(
                                    children: Sessions.map((Session) {
                                      if (Session.completed == true) {
                                        return smallCard(
                                          name: Session.name,
                                          date: DateFormat('d MMM, y').format(
                                              Session.createdAt.toDate()),
                                          sessionId: Session.id,
                                        );
                                      } else {
                                        return Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                top: 30.0),
                                            child: const Text(
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                'No session completed yet'));
                                      }
                                    }).toList(),
                                  )
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 30.0, left: 16.0),
                              child: Text(
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  'All sessions will appear here! You can manage and record videos of your playing sessions.\n\nClick on the "Create New Session" button above to create a new session!'),
                            )
                        ]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
