import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shotsense/screens/singleBall.dart';
import 'package:shotsense/screens/shotTypeStats.dart';
import 'package:shotsense/services/Inferences.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionID;
  final String? sessionName;
  const SessionDetailScreen(
      {Key? key, required this.sessionID, this.sessionName})
      : super(key: key);
  static const routeName = '/sessionDetail';

  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String sessionName = '';
  late Timestamp sessionDate = Timestamp.now();
  late bool isCompleted = false;
  File? _video;
  final ImagePicker _imagePicker = ImagePicker();
  final List<VideoPlayerController> _videoPlayerControllers = [];
  late Map<String, dynamic> _inference = {};
  late List<String> _oversInSession = [];
  late List<Map<String, dynamic>> _ballsInSession = [];
  late String selectedOver = "1";
  late String isgettingInferece = "false";
  late List _sessionStats = [];
  late Map<String, dynamic> sessionData = {};
  late bool isLoadingBalls = true;

  @override
  void initState() {
    super.initState();
    fetchSessionData().then((value) {
      fetchBalls();
    }).then((value) {
      if (mounted) {
        setState(() {
          isLoadingBalls = false;
        });
      }
    });
  }

  Future<void> fetchSessionData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot sessionSnapshot =
            await _firestore.collection('sessions').doc(widget.sessionID).get();

        QuerySnapshot<Map<String, dynamic>> oversInSession = await _firestore
            .collection('sessions')
            .doc(widget.sessionID)
            .collection("overs")
            .get();

        setState(() {
          _oversInSession = oversInSession.docs.map((doc) => doc.id).toList();
          selectedOver = _oversInSession.last;
        });

        print((sessionSnapshot.data()));
        setState(() {
          sessionData = sessionSnapshot.data() as Map<String, dynamic>;
          sessionName =
              (sessionSnapshot.data() as Map<String, dynamic>)['name'];

          sessionDate = (sessionSnapshot.data()
              as Map<String, dynamic>)['createdAt'] as Timestamp;
          isCompleted = (sessionSnapshot.data()
              as Map<String, dynamic>)['completed'] as bool;
        });
      }
    } catch (e) {
      print('Error fetching session data: $e');
    }
  }

  void fetchBalls() async {
    try {
      QuerySnapshot<Map<String, dynamic>> ballsInSession = await _firestore
          .collection('sessions')
          .doc(widget.sessionID)
          .collection('overs')
          .doc(selectedOver)
          .collection('balls')
          .get();

      if (mounted) {
        setState(() {
          _ballsInSession =
              ballsInSession.docs.map((doc) => doc.data()).toList();
        });
      }

      ballsInSession.docs.toList().isNotEmpty
          ? getFrequentShotTypeForSession(false).then((value) {
              if (mounted) {
                setState(() {
                  _sessionStats = value;
                });
              }
            })
          : null;
    } catch (e) {
      print('Error fetching balls: $e');
    }
  }

  Future<void> updateSession(
      String sessionId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .update(updatedData);
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .delete();
      QuerySnapshot<Map<String, dynamic>> oversSnapshot =
          await FirebaseFirestore.instance
              .collection('sessions')
              .doc(sessionId)
              .collection('overs')
              .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> overSnapshot
          in oversSnapshot.docs) {
        QuerySnapshot<Map<String, dynamic>> ballsSnapshot =
            await FirebaseFirestore.instance
                .collection('sessions')
                .doc(sessionId)
                .collection('overs')
                .doc(overSnapshot.id)
                .collection('balls')
                .get();
        for (QueryDocumentSnapshot<Map<String, dynamic>> ballSnapshot
            in ballsSnapshot.docs) {
          await FirebaseFirestore.instance
              .collection('sessions')
              .doc(sessionId)
              .collection('overs')
              .doc(overSnapshot.id)
              .collection('balls')
              .doc(ballSnapshot.id)
              .delete();
        }
        await FirebaseFirestore.instance
            .collection('sessions')
            .doc(sessionId)
            .collection('overs')
            .doc(overSnapshot.id)
            .delete();
      }
    } catch (e) {
      print('Error deleting session: $e');
    }
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _video = File(pickedFile.path);

      _initializeAndShowVideoConfirmationDialog();
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _video = File(pickedFile.path);

      _initializeAndShowVideoConfirmationDialog();
    }
  }

  void _initializeAndShowVideoConfirmationDialog() {
    _videoPlayerControllers.add(VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        _videoPlayerControllers.last.setLooping(true);
        _videoPlayerControllers.last.play();
        _showVideoConfirmationDialog();
      }));
  }

  void _showVideoConfirmationDialog() async {
    Duration duration = _videoPlayerControllers.last.value.duration;
    print("duration ${duration.inSeconds}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Video',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: AspectRatio(
                  aspectRatio: _videoPlayerControllers.last.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerControllers.last),
                ),
              ),
              const SizedBox(height: 16),
              duration.inSeconds <= 5
                  ? Container()
                  : const Text(
                      'Video should be longer than 5 seconds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerControllers.last.dispose();
                        _videoPlayerControllers.removeLast();
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff221D55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  duration.inSeconds <= 5
                      ? ElevatedButton(
                          onPressed: () async {
                            _videoPlayerControllers.last.dispose();
                            _videoPlayerControllers.removeLast();
                            setState(() {
                              isgettingInferece = "true";
                            });
                            fetchData().then((value) async {
                              getFrequentShotTypeForSession(true).then((value) {
                                setState(() {
                                  _sessionStats = value;
                                });
                              });
                              updateShotTypeStat();
                              fetchSessionData().then((value) {
                                setState(() {
                                  selectedOver = _oversInSession.last;
                                });
                                fetchBalls();
                                setState(() {
                                  isgettingInferece = "false";
                                });
                              });
                            });

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff221D55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 122, 122, 122),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 252, 252, 252),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Record a video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
              leading: const Icon(Icons.image),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var overSnapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.sessionID)
        .collection('overs')
        .get();

    var latestOverDoc;

    if (overSnapshot.docs.isNotEmpty) {
      print(overSnapshot.docs.last.id);
      latestOverDoc = overSnapshot.docs.last;
    } else {
      Map<String, Object> dummyMap = {'dummy': 'dummy'};
      // If the latest over doesn't exist, create a new one
      await firestore
          .collection('sessions')
          .doc(widget.sessionID)
          .collection('overs')
          .doc("1")
          .set(dummyMap);
      latestOverDoc = await firestore
          .collection('sessions')
          .doc(widget.sessionID)
          .collection('overs')
          .doc("1")
          .get();
    }

    // Step 2: Get the latest ball within the latest over
    QuerySnapshot ballSnapshot = await firestore
        .collection('sessions')
        .doc(widget.sessionID)
        .collection('overs')
        .doc(latestOverDoc.id)
        .collection('balls')
        .get();

    int nextBall = 1; // Default value if there are no existing balls
    if (ballSnapshot.docs.isNotEmpty) {
      // Extract the last ball's ID and increment it
      int latestBall = int.parse(ballSnapshot.docs.last.id);
      nextBall = latestBall + 1;
      if (nextBall > 6) {
        // If the next ball exceeds 6, increment the over by 1
        // and reset the ball count to 1
        Map<String, Object> dummyMap = {'dummy': 'dummy'};
        await firestore
            .collection('sessions')
            .doc(widget.sessionID)
            .collection('overs')
            .doc((int.parse(latestOverDoc.id) + 1).toString())
            .set(dummyMap);
        latestOverDoc = await firestore
            .collection('sessions')
            .doc(widget.sessionID)
            .collection('overs')
            .doc((int.parse(latestOverDoc.id) + 1).toString())
            .get();
        nextBall = 1;
      }
    }

    DocumentReference ballCollection = firestore
        .collection('sessions')
        .doc(widget.sessionID)
        .collection('overs')
        .doc(latestOverDoc.id)
        .collection('balls')
        .doc(nextBall.toString());

    String inference = await getInference(
        _video!, widget.sessionID, latestOverDoc.id, nextBall.toString());
    _inference = json.decode(inference);

    Map<String, dynamic> ball = {
      'ball_id': Random().nextInt(1000000).toString(),
      'prediction': _inference['prediction'],
      'uri': _inference['video_uri'],
      // 'annotated_uri': _annotation['annotated_uri'],
      // 'annotated_uri': "",
      'recommendation': _inference['recommendation'],
      'ratings': _inference['ratings'],
      'sessionID': widget.sessionID,
      'sessionName': widget.sessionName,
      'userID': _auth.currentUser!.uid,
      'createdAt': Timestamp.now(),
    };

    await ballCollection.set(ball);

    return [latestOverDoc, nextBall];
  }

  Future<void> updateShotTypeStat() async {
    int coverDriveCount = 0;
    int defenceCount = 0;
    int pullShotCount = 0;
    int straightCount = 0;
    int hookCount = 0;
    int cutCount = 0;
    int sweepCount = 0;
    int flickCount = 0;

    int ballHitCount = 0;
    int highestCount = 0;

    String highestShotType = '';

    QuerySnapshot<Map<String, dynamic>> balls = await _firestore
        .collectionGroup('balls')
        .where('userID', isEqualTo: _auth.currentUser!.uid)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> ball in balls.docs) {
      switch (ball.data()['prediction']) {
        case 'Cover Drive':
          coverDriveCount++;
          break;
        case 'Defense':
          defenceCount++;
          break;
        case 'Pull Shot':
          pullShotCount++;
          break;
        case 'Straight Drive':
          straightCount++;
          break;
        case 'Hook Shot':
          hookCount++;
          break;
        case 'Cut Shot':
          cutCount++;
          break;
        case 'Sweep':
          sweepCount++;
          break;
        case 'Flick Shot':
          flickCount++;
          break;
      }
      if (ball.data()["ratings"]["shot"] == "hit") {
        ballHitCount++;
      }
    }

    Map<String, int> counts = {
      'coverDriveCount': coverDriveCount,
      'defenceCount': defenceCount,
      'pullShotCount': pullShotCount,
      'straightCount': straightCount,
      'hookCount': hookCount,
      'cutCount': cutCount,
      'sweepCount': sweepCount,
      'flickCount': flickCount,
    };

    counts.forEach((shotType, count) {
      if (count > highestCount) {
        highestCount = count;
        switch (shotType) {
          case 'coverDriveCount':
            highestShotType = 'Cover Drive';
            break;
          case 'defenceCount':
            highestShotType = 'Defense';
            break;
          case 'pullShotCount':
            highestShotType = 'Pull Shot';
            break;
          case 'straightCount':
            highestShotType = 'Straight Drive';
            break;
          case 'hookCount':
            highestShotType = 'Hook Shot';
            break;
          case 'cutCount':
            highestShotType = 'Cut Shot';
            break;
          case 'sweepCount':
            highestShotType = 'Sweep';
            break;
          case 'flickCount':
            highestShotType = 'Flick Shot';
            break;
        }
      }
    });

    Map<String, dynamic> allData = {
      'coverDriveCount': coverDriveCount,
      'defenceCount': defenceCount,
      'pullShotCount': pullShotCount,
      'straightCount': straightCount,
      'hookCount': hookCount,
      'cutCount': cutCount,
      'sweepCount': sweepCount,
      'flickCount': flickCount,
      'highestShotType': highestShotType,
      'ballHitCount': ballHitCount,
      'totalBalls': balls.docs.length,
    };

    await FirebaseFirestore.instance
        .collection('ShotTypeStats')
        .doc(_auth.currentUser!.uid)
        .set(allData, SetOptions(merge: true));
  }

  Future<List<Object>> getFrequentShotTypeForSession(bool newUpload) async {
    try {
      int coverDriveCount = 0;
      int defenceCount = 0;
      int pullShotCount = 0;
      int straightCount = 0;
      int hookCount = 0;
      int cutCount = 0;
      int sweepCount = 0;
      int flickCount = 0;

      int ballHitCount = 0;
      int highestCount = 0;

      int totalBalls = 0;

      String highestShotType = '';

      QuerySnapshot<Map<String, dynamic>> overs = await FirebaseFirestore
          .instance
          .collection('sessions')
          .doc(widget.sessionID)
          .collection('overs')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> over in overs.docs) {
        QuerySnapshot<Map<String, dynamic>> balls = await FirebaseFirestore
            .instance
            .collection('sessions')
            .doc(widget.sessionID)
            .collection('overs')
            .doc(over.id)
            .collection('balls')
            .get();

        for (QueryDocumentSnapshot<Map<String, dynamic>> ball in balls.docs) {
          switch (ball.data()['prediction']) {
            case 'Cover Drive':
              coverDriveCount++;
              break;
            case 'Defense':
              defenceCount++;
              break;
            case 'Pull Shot':
              pullShotCount++;
              break;
            case 'Straight Drive':
              straightCount++;
              break;
            case 'Hook Shot':
              hookCount++;
              break;
            case 'Cut Shot':
              cutCount++;
              break;
            case 'Sweep':
              sweepCount++;
              break;
            case 'Flick Shot':
              flickCount++;
              break;
          }
          if (ball.data()["ratings"]["shot"] == "hit") {
            ballHitCount++;
          }
          totalBalls++;
        }
      }

      Map<String, int> counts = {
        'coverDriveCount': coverDriveCount,
        'defenceCount': defenceCount,
        'pullShotCount': pullShotCount,
        'straightCount': straightCount,
        'hookCount': hookCount,
        'cutCount': cutCount,
        'sweepCount': sweepCount,
        'flickCount': flickCount,
      };

      counts.forEach((shotType, count) {
        if (count > highestCount) {
          highestCount = count;
          switch (shotType) {
            case 'coverDriveCount':
              highestShotType = 'Cover Drive';
              break;
            case 'defenceCount':
              highestShotType = 'Defense';
              break;
            case 'pullShotCount':
              highestShotType = 'Pull Shot';
              break;
            case 'straightCount':
              highestShotType = 'Straight Drive';
              break;
            case 'hookCount':
              highestShotType = 'Hook Shot';
              break;
            case 'cutCount':
              highestShotType = 'Cut Shot';
              break;
            case 'sweepCount':
              highestShotType = 'Sweep';
              break;
            case 'flickCount':
              highestShotType = 'Flick Shot';
              break;
          }
        }
      });

      Map<String, dynamic> allData = {
        'coverDriveCount': coverDriveCount,
        'defenceCount': defenceCount,
        'pullShotCount': pullShotCount,
        'straightCount': straightCount,
        'hookCount': hookCount,
        'cutCount': cutCount,
        'sweepCount': sweepCount,
        'flickCount': flickCount,
        'highestShotType': highestShotType,
        'ballHitCount': ballHitCount,
        'totalBalls': totalBalls,
      };
      if (newUpload) {
        await FirebaseFirestore.instance
            .collection('sessions')
            .doc(widget.sessionID)
            .update(allData);
      }

      return [highestShotType, ballHitCount, totalBalls];
    } catch (e) {
      print('Error getting shot type stats: $e');
      return [];
    }
  }

  var height;
  var width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: (isgettingInferece == "false"),
        child: Scaffold(
          appBar: CustomAppBar(
              title: "Session Details", isgettingInferece: isgettingInferece),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFFF5F5F5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(
                        top: 6, bottom: 0, left: 20, right: 20),
                    title: Text(
                      widget.sessionName!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('d MMM, y').format(sessionDate.toDate()),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.white),
                //     borderRadius: BorderRadius.circular(20.0),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.15),
                //         spreadRadius: 1,
                //         blurRadius: 8,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //     color: Colors.white,
                //   ),
                //   child: ListTile(
                //     contentPadding: const EdgeInsets.only(
                //         top: 6, bottom: 0, left: 20, right: 20),
                //     title: _sessionStats.isNotEmpty
                //         ? Text(
                //             _sessionStats[0],
                //             style: TextStyle(
                //               fontSize: height * 0.03,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           )
                //         : Text(
                //             'Loading...',
                //             style: TextStyle(
                //               fontSize: height * 0.03,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //     subtitle: const Text(
                //       "Most Frequent Shot",
                //       style: TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold,
                //         color: Color.fromARGB(255, 123, 123, 123),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sessionStats.isNotEmpty
                        ? _buildStatContainer(
                            "Ball Hit Accuracy \n\t(${_sessionStats[2]} Balls Played)",
                            "${((_sessionStats[1] / _sessionStats[2]) * 100).floor()}%",
                            false)
                        : _buildStatContainer(
                            "Ball Hit Accuracy", "...", false),
                    const SizedBox(width: 15.0),
                    _sessionStats.isNotEmpty
                        ? _buildStatContainer(
                            "Frequent Shot Type", _sessionStats[0], true)
                        : _buildStatContainer(
                            "Frequent Shot Type", "...", false),
                  ],
                ),
                const SizedBox(height: 15.0),
                _buildOverSection(),
                const SizedBox(height: 15.0),
                isLoadingBalls
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: _buildVideosSection(),
                      )
              ],
            ),
          ),
          floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (isCompleted == false)
                  ? ElevatedButton(
                      onPressed: () {
                        if (isgettingInferece == "true") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please wait for the inference to complete'),
                            ),
                          );
                        } else if (_oversInSession.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please add a video to the session before finishing it'),
                            ),
                          );
                        } else {
                          setState(() {
                            isCompleted = true;
                          });
                          updateSession(widget.sessionID, {'completed': true});
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (isgettingInferece == "false")
                            ? (const Color(0xff221D55))
                            : (const Color.fromARGB(255, 167, 167, 167)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Text(
                          'Complete Session',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCompleted = true;
                        });
                        deleteSession(widget.sessionID)
                            .then((value) => updateShotTypeStat());
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Session has been deleted successfully!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 165, 17, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text(
                          'Delete Session',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
        ));
  }

  Widget _buildStatContainer(String label, String value, bool isTappable) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              isTappable
                  ? Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ShotTypeStats(
                          sessionStats: sessionData,
                        );
                      },
                    ))
                  : null;
            },
            child: Container(
              // width: MediaQuery.of(context).size.width / 2.3,
              height: 120,

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  // const SizedBox(height: 30),
                ],
              ),
            )));
  }

  Widget _buildOverSection() {
    if (isgettingInferece == "false") {
      return InkWell(
        onTap: () => {_showOverDropdown(context)},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Text(
                "Over $selectedOver",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 11, 11, 11),
                ),
              ),
              const Icon(Icons.arrow_drop_down_rounded, size: 50),
            ]),
            // const SizedBox(width: double.infinity, height: 0),
            // const SizedBox(width: 100, height: 0),
            Container(
              child: isCompleted
                  ? Container()
                  : GestureDetector(
                      onTap: () => _showImagePickerBottomSheet(),
                      child: const Icon(
                        Icons.add_circle,
                        size: 35,
                        color: Color.fromARGB(255, 11, 51, 84),
                      ),
                    ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please wait for the inference to complete'),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text(
                "Over $selectedOver",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 160, 160, 160),
                ),
              ),
              const Icon(
                Icons.arrow_drop_down_rounded,
                size: 50,
                color: Color.fromARGB(255, 160, 160, 160),
              ),
            ]),
            Container(
                child: isCompleted
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please wait for the inference to complete'),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.add_circle,
                          size: 35,
                          color: Color.fromARGB(255, 160, 160, 160),
                        ),
                      )),
          ],
        ),
      );
    }
  }

  Widget _buildVideosSection() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_ballsInSession.isNotEmpty)
              for (var index = 0; index < _ballsInSession.length; index++)
                _ballsInSession[index]["annotated_uri"] == null
                    ? InkWell(
                        onTap: () async {
                          if (isgettingInferece == "true") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please wait for the inference to complete'),
                              ),
                            );
                            return;
                          } else {
                            final gsvideoReference = FirebaseStorage.instance
                                .refFromURL(_ballsInSession[index]["uri"]);
                            final urlVideo =
                                await gsvideoReference.getDownloadURL();
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SingleBallPage(
                                  ballData: _ballsInSession[index],
                                  url: urlVideo,
                                  annotated_url: "",
                                );
                              },
                            ));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:
                                          Color.fromARGB(159, 158, 158, 158)))),
                          child: _buildVideoItem(index),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          if (isgettingInferece == "true") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please wait for the inference to complete'),
                              ),
                            );
                            return;
                          } else {
                            final gsReference = FirebaseStorage.instance
                                .refFromURL(
                                    _ballsInSession[index]["annotated_uri"]);
                            final url = await gsReference.getDownloadURL();
                            final gsvideoReference = FirebaseStorage.instance
                                .refFromURL(_ballsInSession[index]["uri"]);
                            final urlVideo =
                                await gsvideoReference.getDownloadURL();
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SingleBallPage(
                                  ballData: _ballsInSession[index],
                                  url: urlVideo,
                                  annotated_url: url,
                                );
                              },
                            ));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:
                                          Color.fromARGB(159, 158, 158, 158)))),
                          child: _buildVideoItem(index),
                        ),
                      ),
            if (isgettingInferece == "true")
              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(159, 158, 158, 158)))),
                  child: Skeletonizer(
                    enabled: isgettingInferece == "true",
                    child: _buildVideoLoader(),
                  )),
            if (isgettingInferece == "true")
              const Text(
                "Getting Inference, It will take a few seconds...",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 142, 142, 142),
                ),
              ),
            if (_ballsInSession.isEmpty && isgettingInferece == "false")
              Container(
                padding: const EdgeInsets.all(
                  100,
                ),
                child: const Text("No Videos added for this over"),
              ),
            const SizedBox(height: 110.0),
          ],
        ));
  }

  Widget _buildVideoItem(int index) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 5),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/BallIcon.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              "${selectedOver}.${index + 1}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  _ballsInSession[index]
                      ["prediction"], // Removed 'const' keyword
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    DateFormat('d MMM, y').format(sessionDate.toDate()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(187, 21, 30, 35),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoLoader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 5),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/BallIcon.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Center(
            child: Text(
              "",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280,
                child: Text(
                  "Getting Inference", // Removed 'const' keyword
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "--- - ----",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(187, 21, 30, 35),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showOverDropdown(BuildContext context) {
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
                  'Select Over',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _oversInSession.length,
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: const EdgeInsets.only(left: 30),
                      title: Text(
                        "Over ${_oversInSession[index]}",
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      shape: const Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(149, 158, 158, 158),
                          width: 1.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedOver = _oversInSession[index];
                          fetchBalls();
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
