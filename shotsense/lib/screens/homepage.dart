import 'package:flutter/material.dart';
import '../widgets/custom_appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  String? displayName;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      fetchDisplayName();
    }
  }

  Future<void> fetchDisplayName() async {
    try {
      DocumentSnapshot userDoc = await users.doc(user!.uid).get();
      setState(() {
        displayName = userDoc['displayName'];
      });
    } catch (e) {
      print('Error fetching display name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'ShotSense',
        ),
        // later for adding a custom app bar
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15.0),
                        Text("Welcome Back, $displayName!",
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff221D55))
                        ),
                        const SizedBox(height: 15.0),
                        const Text("Overall Stats",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 79, 79, 79))
                        ),
                        const SizedBox(height: 15.0),
                        Container(
<<<<<<< Updated upstream
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: const ListTile(
                              // leading: ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              title: Text('Most Frequent Shot Played',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 123, 123, 123))),
                              subtitle: Text(
                                'Cover Drive',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 79, 79, 79)),
                              )),
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: const ListTile(
                              // leading: ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              title: Text('Overall Accuracy',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 123, 123, 123))),
                              subtitle: Text(
                                '84%',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 79, 79, 79)),
                              )),
                        ),
                        const SizedBox(height: 15.0),
                        const Text("Previous Session Played",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 79, 79, 79))),

                        const SizedBox(height: 15.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5.0),
                              const ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: Text('Most Frequent Shot Played',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: Text('Cover Drive',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        Color.fromARGB(255, 79, 79, 79))),
                              ),
                              ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: const Text('Balls Hit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: '35/43 ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                            Color.fromARGB(255, 79, 79, 79),
                                          fontWeight: FontWeight.w600,
=======
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0),
                                Text("Welcome Back, $displayName!",
                                    style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xff221D55))),
                                const SizedBox(height: 15.0),
                                (_mostFrequentShot != null &&
                                        _mostFrequentShot!.isNotEmpty &&
                                        _totalBalls != null &&
                                        _totalHits != null &&
                                        _totalHits != null &&
                                        _totalBalls != 0 &&
                                        _lastSession != null)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Overall Stats",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 79, 79, 79))),
                                          const SizedBox(height: 15.0),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
                                                // leading: ClipRRect(
                                                //   borderRadius: BorderRadius.circular(8.0),
                                                // ),
                                                title: const Text(
                                                    'Most Frequent Shot Played',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            123,
                                                            123,
                                                            123))),
                                                subtitle: (_mostFrequentShot !=
                                                            null &&
                                                        _mostFrequentShot!
                                                            .isNotEmpty)
                                                    ? Text(
                                                        _mostFrequentShot!,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    79,
                                                                    79,
                                                                    79)),
                                                      )
                                                    : const Text(
                                                        '...',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    79,
                                                                    79,
                                                                    79)),
                                                      )),
                                          ),
                                          const SizedBox(height: 15.0),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
                                                // leading: ClipRRect(
                                                //   borderRadius: BorderRadius.circular(8.0),
                                                // ),
                                                title: const Text(
                                                    'Overall Hit Accuracy',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            123,
                                                            123,
                                                            123))),
                                                subtitle: (_totalBalls ==
                                                            null ||
                                                        _totalHits == null ||
                                                        _totalBalls == 0 ||
                                                        _totalHits == 0)
                                                    ? const Text(
                                                        '0%',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    79,
                                                                    79,
                                                                    79)),
                                                      )
                                                    : Text(
                                                        "${((_totalHits! / _totalBalls!) * 100).floor()}% of ${_totalBalls} balls played",
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    79,
                                                                    79,
                                                                    79)),
                                                      )),
                                          ),
                                          const SizedBox(height: 15.0),
                                          const Text("Previous Session Played",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 79, 79, 79))),
                                          const SizedBox(height: 15.0),
                                          Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.15),
                                                    spreadRadius: 1,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 5.0),
                                                  ListTile(
                                                    // leading: ClipRRect(
                                                    //   child: Text('1'),
                                                    // ),
                                                    title: const Text(
                                                        'Most Frequent Shot Played',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    123,
                                                                    123))),
                                                    subtitle: _lastSession !=
                                                                null &&
                                                            (_lastSession as Map<
                                                                    String,
                                                                    dynamic>)
                                                                .containsKey(
                                                                    'highestShotType')
                                                        ? Text(
                                                            (_lastSession as Map<
                                                                    String,
                                                                    dynamic>)[
                                                                'highestShotType'],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        79,
                                                                        79,
                                                                        79)),
                                                          )
                                                        : const Text(
                                                            'Play a ball in the previously created session to get stats',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        79,
                                                                        79,
                                                                        79))),
                                                  ),
                                                  ListTile(
                                                    // leading: ClipRRect(
                                                    //   child: Text('1'),
                                                    // ),
                                                    title: const Text(
                                                        'Balls Hit',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    123,
                                                                    123))),
                                                    subtitle: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          _lastSession !=
                                                                      null &&
                                                                  (_lastSession as Map<
                                                                          String,
                                                                          dynamic>)
                                                                      .containsKey(
                                                                          'highestShotType')
                                                              ? TextSpan(
                                                                  text:
                                                                      '${(_lastSession as Map<String, dynamic>)['ballHitCount']}/${(_lastSession as Map<String, dynamic>)['totalBalls']} ',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            79,
                                                                            79,
                                                                            79),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                )
                                                              : const TextSpan(
                                                                  text: '0/0 ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            79,
                                                                            79,
                                                                            79),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                          const TextSpan(
                                                            text: 'balls hit',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      79,
                                                                      79,
                                                                      79),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // add one for the date
                                                  ListTile(
                                                    // leading: ClipRRect(
                                                    //   child: Text('1'),
                                                    // ),
                                                    title: const Text('Date',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    123,
                                                                    123))),
                                                    subtitle: Text(
                                                      _date != null
                                                          ? _date!
                                                          : '...',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color.fromARGB(
                                                              255, 79, 79, 79)),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
>>>>>>> Stashed changes
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'balls hit',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 79, 79, 79),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // add one for the date
                              const ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: Text('Date',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: Text(
                                  '11/04/2023',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 79, 79, 79),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ))
    );
  }
}