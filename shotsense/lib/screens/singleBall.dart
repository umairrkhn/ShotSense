import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SingleBallPage extends StatefulWidget {
  final Map<String, dynamic> ballData;
  final String url;
  const SingleBallPage({Key? key, required this.url, required this.ballData})
      : super(key: key);

  @override
  _SingleBallPageScreen createState() => _SingleBallPageScreen();
}

class _SingleBallPageScreen extends State<SingleBallPage> {
  late VideoPlayerController _videoPlayerController =
      VideoPlayerController.contentUri(Uri.parse(widget.url));
  late String _aspectRatio =
      _videoPlayerController.value.aspectRatio.toString();
  late Map<String, dynamic>? _sessionData = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String sessionName = '';
  late Timestamp sessionDate = Timestamp.now();
  late bool isCompleted = false;
  late List<String> _oversInSession = [];

  @override
  void initState() {
    super.initState();
    fetchSessionData();
  }

  Future<void> fetchSessionData() async {
    try {
      DocumentSnapshot sessionSnapshot = await _firestore
          .collection('sessions')
          .doc(widget.ballData["sessionID"])
          .get();

      // print((sessionSnapshot.data() as Map<String, dynamic>)['name']);
      setState(() {
        sessionName = (sessionSnapshot.data() as Map<String, dynamic>)['name'];
        sessionDate = (sessionSnapshot.data()
            as Map<String, dynamic>)['createdAt'] as Timestamp;
        isCompleted = (sessionSnapshot.data()
            as Map<String, dynamic>)['completed'] as bool;
      });
    } catch (e) {
      print('Error fetching session data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Ball Details"),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFFF5F5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15.0),
              buildContainer(
                context,
                sessionName,
                DateFormat("MMMM d, yyyy")
                    .format(sessionDate.toDate())
                    .toString(),
                true,
              ),
              const SizedBox(height: 15.0),
              buildContainer(
                  context, widget.ballData["prediction"], "Shot Type", false),
              const SizedBox(height: 15.0),
              Container(
                height: 620,
                padding: const EdgeInsets.all(8.0),
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
                child: _buildVideoPlayer(),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 500,
                padding: const EdgeInsets.all(8.0),
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.ballData["recommendation"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  Widget _buildVideoPlayer() {
    _videoPlayerController.initialize();
    _videoPlayerController.play();

    print("aspect ratio");
    print(_videoPlayerController.value.aspectRatio);

    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: AspectRatio(
            aspectRatio: 9 / 16, child: VideoPlayer(_videoPlayerController)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoPlayerController!.value.isPlaying
                ? _videoPlayerController!.pause()
                : _videoPlayerController!.play();
          });
        },
        child: Icon(
          _videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String title, String subtitle) {
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
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

Widget buildContainer(BuildContext context, String titleName, String subtitle,
    bool isFirstContainer) {
  return Container(
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
        top: 6,
        bottom: 0,
        left: 20,
        right: 20,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isFirstContainer
              ? const Text(
                  'From the session',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 71, 71, 71),
                  ),
                )
              : const SizedBox(height: 0),
          Text(
            titleName,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 123, 123, 123),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    ),
  );
}
