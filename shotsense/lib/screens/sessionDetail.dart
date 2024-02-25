import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:shotsense/classes/session.dart';
import 'package:intl/intl.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionID;
  const SessionDetailScreen({Key? key, required this.sessionID})
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

  @override
  void initState() {
    super.initState();
    fetchSessionData();
  }

  Future<void> fetchSessionData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot sessionSnapshot =
            await _firestore.collection('sessions').doc(widget.sessionID).get();

        // print((sessionSnapshot.data() as Map<String, dynamic>)['name']);
        setState(() {
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

  Future<void> updateSession(
      String sessionId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .update(updatedData);
  }

  Future<void> deleteSession(String sessionId) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .delete();
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
        _showVideoConfirmationDialog();
      }));
  }

  void _showVideoConfirmationDialog() {
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
              AspectRatio(
                aspectRatio: _videoPlayerControllers.last.value.aspectRatio,
                child: VideoPlayer(_videoPlayerControllers.last),
              ),
              const SizedBox(height: 16),
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerControllers.last.pause();
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
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
var height;
var width;
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: "Session Details"),
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
                  sessionName,
                  style:  TextStyle(
                    fontSize: height*0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  DateFormat('d MMM y').format(sessionDate.toDate()),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 123, 123, 123),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatContainer("Ball Hit Accuracy", "84%"),
                _buildStatContainer("Frequent Shot Type", "Cover Drive"),
              ],
            ),
            const SizedBox(height: 15.0),
            _buildOverSection(),
            const SizedBox(height: 15.0),
            _buildVideosSection(),
          ],
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (isCompleted == false)
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = true;
                    });
                    updateSession(widget.sessionID, {'completed': true});
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff221D55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Text(
                      'Finish Session',
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
                    deleteSession(widget.sessionID);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 165, 17, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
    );
  }

  Widget _buildStatContainer(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: 192,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildOverSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Row(
          children: [
            InkWell(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Over 4",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 11, 11, 11),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded, size: 50),
                  const SizedBox(width: 200),
                  isCompleted
                      ? Container()
                      : GestureDetector(
                          onTap: () => _showImagePickerBottomSheet(),
                          child: const Icon(
                            Icons.add_circle,
                            size: 35,
                            color: Color.fromARGB(255, 11, 51, 84),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_videoPlayerControllers.isNotEmpty)
          for (var index = 0; index < _videoPlayerControllers.length; index++)
            _buildVideoItem(index),
        if (_videoPlayerControllers.isEmpty)
          Container(
            padding: const EdgeInsets.all(100),
            child: const Text("No Videos added for this over"),
          ),
        const SizedBox(height: 15.0),
      ],
    );
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
              "4.${index + 1}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280,
                child: Text(
                  "Defense Shot",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Jan 1 2024",
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
}
