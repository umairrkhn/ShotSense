import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shotsense/screens/singleBall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShotScreen extends StatefulWidget {
  const ShotScreen({Key? key}) : super(key: key);
  static const routeName = '/shots';

  @override
  _ShotScreenState createState() => _ShotScreenState();
}

class _ShotScreenState extends State<ShotScreen> {
  String selectedShotType = 'All';

  List<String> shotTypes = [
    'All',
    'Cover Drive',
    'Straight',
    'Defence',
    'Hook',
    'Pull',
    'Cut',
    'Sweep',
    'Flick',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    gettingBalls();
    // printBalls();
  }

  // void printBalls() async {
  //   QuerySnapshot<Map<String, dynamic>> Sessions =
  //       // getting balls from the collection of overs in the collection of sessions

  //       await _firestore
  //           .collection('sessions')
  //           .where('userId', isEqualTo: _auth.currentUser!.uid)
  //           .get();
  //   QuerySnapshot<Map<String, dynamic>> overs;
  //   QuerySnapshot<Map<String, dynamic>> balls;
  //   Sessions.docs.forEach((session) async {
  //     overs = await _firestore
  //         .collection('sessions')
  //         .doc(session.id)
  //         .collection('overs')
  //         .get();

  //     overs.docs.forEach((over) async {
  //       balls = await _firestore
  //           .collection('sessions')
  //           .doc(session.id)
  //           .collection('overs')
  //           .doc(over.id)
  //           .collection('balls')
  //           .get();
  //       balls.docs.forEach((ball) {
  //         print(ball.data());
  //       });
  //       // return balls.docs;
  //     });
  //   });
  // }

  Future<List> gettingBalls() async {
    QuerySnapshot<Map<String, dynamic>> balls = await _firestore
        .collectionGroup('balls')
        .where('userID', isEqualTo: _auth.currentUser!.uid)
        .get();

    var filteredballs = balls.docs.where((ball) {
      if (selectedShotType == 'All') {
        return true;
      }
      return ball.data()['prediction'] == selectedShotType;
    }).toList();
    return filteredballs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Shots"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedShotType,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(255, 38, 5, 116),
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showShotTypeDropdown(context);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.filter,
                        size: 22,
                        color: Color.fromARGB(255, 38, 5, 116),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15.0),
                          FutureBuilder<List>(
                            future: gettingBalls(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('No data available');
                              } else {
                                List balls = snapshot.data as List;
                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: balls.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10.0),
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> ballData =
                                        balls[index].data();
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return SingleBallPage();
                                            },
                                          ));
                                        },
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/ShotSense-logo.png',
                                            width: 80,
                                            height: 45,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(ballData["prediction"]),
                                        subtitle: Text("subtitle"),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showShotTypeDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Shot Type',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: shotTypes.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        shotTypes[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        setState(() {
                          selectedShotType = shotTypes[index];
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
