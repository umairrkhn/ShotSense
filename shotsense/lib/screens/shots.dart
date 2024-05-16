import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shotsense/screens/singleBall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShotScreen extends StatefulWidget {
  const ShotScreen({super.key});
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

  User? user = FirebaseAuth.instance.currentUser;
  bool ballsExist = false;

  @override
  void initState() {
    super.initState();
    getBalls().then((value) => setState(() {
          if (value.isNotEmpty) {
            ballsExist = true;
          } else {
            ballsExist = false;
          }

          if (value.isNotEmpty) {
            List<String> predictions = [];
            value.forEach((ball) {
              predictions.add(ball.data()['prediction']);
            });
            shotTypes = ['All', ...predictions.toSet()];
          }
        }));
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

  Future<List> getBalls() async {
    // List<String> sessionNames = [];
    QuerySnapshot<Map<String, dynamic>> balls = await _firestore
        .collectionGroup('balls')
        .where('userID', isEqualTo: user!.uid)
        .get();

    // balls.docs.forEach((ball) async {
    //   DocumentSnapshot sessionSnapshot = await _firestore
    //       .collection('sessions')
    //       .doc(ball.data()['sessionID'])
    //       .get();
    //   // var sessionName =
    //   //     await (sessionSnapshot.data() as Map<String, dynamic>)['name'];

    //   // sessionNames.add(sessionName);
    // });

    if (balls.docs.isEmpty) {
      return [];
    }

    var filteredballs = balls.docs.where((ball) {
      if (selectedShotType == 'All') {
        return true;
      }
      return ball.data()['prediction'] == selectedShotType;
    }).toList();

    // print([filteredballs, sessionNames]);

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
                  ballsExist
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedShotType,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        const Color.fromARGB(255, 38, 5, 116),
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
                        )
                      : Container(),
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
                              const SizedBox(height: 10.0),
                              FutureBuilder<List>(
                                future: getBalls(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: Padding(
                                            padding:
                                                EdgeInsets.only(top: 100.0),
                                            child:
                                                const CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.data!.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(
                                          top: 30.0, left: 16.0),
                                      child: Text(
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          'All recorded balls will appear here! You can manage and check annotated videos and performance stats.\n\nClick "Create New Session" button in the sessions tab to create a new session and add balls.'),
                                    );
                                  } else {
                                    List balls = snapshot.data as List;
                                    return ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: balls.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.0),
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> ballData =
                                            balls[index].data();

                                        return Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: ballData["annotated_uri"] ==
                                                  null
                                              ? ListTile(
                                                  onTap: () async {
                                                    final gsReference =
                                                        FirebaseStorage.instance
                                                            .refFromURL(
                                                                ballData[
                                                                    "uri"]);
                                                    final url =
                                                        await gsReference
                                                            .getDownloadURL();
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return SingleBallPage(
                                                            ballData: ballData,
                                                            url: url,
                                                            annotated_url: "");
                                                      },
                                                    ));
                                                  },
                                                  // leading: ClipRRect(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           8.0),
                                                  //   child: Image.asset(
                                                  //     'assets/images/ShotSense-logo.png',
                                                  //     width: 80,
                                                  //     height: 45,
                                                  //     fit: BoxFit.cover,
                                                  //   ),
                                                  // ),
                                                  leading: const Icon(
                                                    Icons.sports_cricket,
                                                    size: 40,
                                                    color: Color.fromARGB(
                                                        255, 78, 78, 78),
                                                  ),
                                                  title: Text(
                                                      "From \b${ballData["sessionName"]}"),
                                                  subtitle: Text(
                                                    // "From ${ballData["createdAt"]}",
                                                    "${DateFormat("MMMM d, yyyy").format(ballData["createdAt"].toDate()).toString()}",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              : // if ball is annotated, show the annotated video

                                              ListTile(
                                                  onTap: () async {
                                                    final gsAnotattedReference =
                                                        FirebaseStorage.instance
                                                            .refFromURL(ballData[
                                                                "annotated_uri"]);
                                                    final url =
                                                        await gsAnotattedReference
                                                            .getDownloadURL();
                                                    final gsvideoReference =
                                                        FirebaseStorage.instance
                                                            .refFromURL(
                                                                ballData[
                                                                    "uri"]);
                                                    final urlVideo =
                                                        await gsvideoReference
                                                            .getDownloadURL();
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return SingleBallPage(
                                                            ballData: ballData,
                                                            url: urlVideo,
                                                            annotated_url: url);
                                                      },
                                                    ));
                                                  },
                                                  // leading: ClipRRect(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           8.0),
                                                  //   child: Image.asset(
                                                  //     'assets/images/ShotSense-logo.png',
                                                  //     width: 80,
                                                  //     height: 45,
                                                  //     fit: BoxFit.cover,
                                                  //   ),
                                                  // ),
                                                  leading: const Icon(
                                                    Icons.circle_rounded,
                                                    size: 40,
                                                    color: Color.fromARGB(
                                                        255, 78, 78, 78),
                                                  ),
                                                  title: Text(
                                                      "From \b${ballData["sessionName"]}"),
                                                  subtitle: Text(
                                                    // "From ${ballData["createdAt"]}",
                                                    "${DateFormat("MMMM d, yyyy").format(ballData["createdAt"].toDate()).toString()}",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),
                                                  )),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                  // )),
                ],
              )),
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
          scrollDirection: Axis.vertical,
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
                    // shrinkWrap: true,
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
