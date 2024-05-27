// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

List<Color> getRatingColors(String rating) {
  switch (rating) {
    case 'bad':
      return [
        Colors.red.shade400,
        Colors.red.shade300,
        Colors.red.shade200,
        Colors.red.shade100,
        Colors.red.shade50,
      ];
    case 'ok':
      return [
        Colors.yellow.shade400,
      ];
    case 'good':
      return [
        const Color.fromARGB(255, 165, 255, 62),
        const Color.fromARGB(255, 165, 255, 62),
        const Color.fromARGB(255, 165, 255, 62),
        const Color.fromARGB(255, 165, 255, 62),
        const Color.fromARGB(255, 165, 255, 62),
      ];
    case 'ideal':
      return [
        Colors.blue.shade400,
        Colors.blue.shade400,
        Colors.blue.shade400,
        Colors.blue.shade400,
        Colors.blue.shade400,
      ];
    default:
      return [
        Colors.grey.shade400,
      ];
  }
}

class SingleBallPage extends StatefulWidget {
  final Map<String, dynamic> ballData;
  final String url;
  final String annotated_url;
  const SingleBallPage(
      {Key? key,
      required this.url,
      required this.annotated_url,
      required this.ballData})
      : super(key: key);

  @override
  _SingleBallPageScreen createState() => _SingleBallPageScreen();
}

class _SingleBallPageScreen extends State<SingleBallPage> {
  late bool _videoIsLoading = true;
  late bool _videoIsLoadingAnnotated = true;
  late String _selectedVideo = 'video';

  late VideoPlayerController _videoPlayerControllerAnnotated =
      VideoPlayerController.network(widget.annotated_url);
  late VideoPlayerController _videoPlayerController =
      VideoPlayerController.network(widget.url);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String sessionName = '';
  late Timestamp sessionDate = Timestamp.now();

  @override
  void initState() {
    super.initState();
    fetchSessionData();

    initializeVideos();
  }

  void initializeVideos() async {
    await _videoPlayerController.initialize().then((value) {
      if (mounted) {
        setState(() {
          _videoIsLoading = false;
        });
      }
    });
    widget.annotated_url != ""
        ? await _videoPlayerControllerAnnotated.initialize().then((value) {
            if (mounted) {
              setState(() {
                _videoIsLoadingAnnotated = false;
              });
            }
          })
        : null;
  }

  Future<void> fetchSessionData() async {
    try {
      DocumentSnapshot sessionSnapshot = await _firestore
          .collection('sessions')
          .doc(widget.ballData["sessionID"])
          .get();

      setState(() {
        sessionName = (sessionSnapshot.data() as Map<String, dynamic>)['name'];
        sessionDate = (widget.ballData["createdAt"] as Timestamp);
      });
    } catch (e) {
      print('Error fetching session data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Ball Details"),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15.0),
              buildContainer(
                context,
                widget.ballData["ball_title"] ?? "",
                DateFormat("MMMM d, yyyy")
                    .format(sessionDate.toDate())
                    .toString(),
                true,
              ),
              // const SizedBox(height: 15.0),
              // buildContainer(
              //     context, widget.ballData["prediction"], "Shot Type", false),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedVideo = 'video';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: _selectedVideo == 'video'
                            ? Color.fromARGB(255, 205, 32, 109)
                            : null,
                      ),
                      child: Text(
                        'Original Video',
                        style: TextStyle(
                          color:
                              _selectedVideo == 'video' ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedVideo = 'annotated';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: _selectedVideo == 'annotated'
                            ? Color.fromARGB(255, 205, 32, 109)
                            : null,
                      ),
                      child: Text(
                        'Annotated Video',
                        style: TextStyle(
                          color: _selectedVideo == 'annotated'
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),

              Container(
                height: MediaQuery.of(context).size.width * (14.4 / 9),
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
                child: _selectedVideo == "video"
                    ? _buildVideoPlayer()
                    : widget.annotated_url == ""
                        ? _buildVideoPlayerAnnotated(true)
                        : _buildVideoPlayerAnnotated(false),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  _buildStatBox(
                      context, widget.ballData["prediction"], "Shot Type"),
                  SizedBox(
                      width: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width - 10)),
                  _buildStatBox(
                      context,
                      widget.ballData["ratings"]["shot"] == "hit"
                          ? "Shot Hit"
                          : "Shot Missed",
                      "Hit/Miss"),
                ],
              ),

              const SizedBox(height: 15.0),
              Container(
                  // height: 500,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white),
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
                      Row(
                        children: [
                          Expanded(
                              child: buildRatingContainer(
                                  context,
                                  widget.ballData["ratings"]["footwork"],
                                  "Footwork")),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: buildRatingContainer(
                                  context,
                                  widget.ballData["ratings"]["shot_choice"],
                                  "Shot Choice")),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: buildRatingContainer(context,
                                widget.ballData["ratings"]["timing"], "Timing"),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 4.0),
                      // const Divider(
                      //   color: Color.fromARGB(255, 209, 209, 209),
                      //   thickness: 1,
                      // ),
                      // const SizedBox(height: 4.0),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                      //   child: Text(
                      //     widget.ballData["recommendation"],
                      //     style: const TextStyle(
                      //       fontSize: 20,
                      //       // fontWeight: FontWeight.bold,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // )
                    ],
                  )),
              const SizedBox(height: 15.0),
              Container(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 16, right: 16, top: 4),
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
                      const Text(
                        "Recommendation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.ballData["recommendation"],
                        style: const TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        )));
  }

  Widget _buildVideoPlayer() {
    return Scaffold(
      body: _videoIsLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: VideoPlayer(_videoPlayerController)),
            ),
      floatingActionButton: _videoIsLoading == true
          ? Center(
              child: Container(),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                      : _videoPlayerController.play();
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

  Widget _buildVideoPlayerAnnotated(bool isProcessing) {
    // !isProcessing ? _videoPlayerControllerAnnotated.play() : null;

    return !isProcessing
        ? Scaffold(
            body: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: (_videoIsLoadingAnnotated == false)
                      ? VideoPlayer(_videoPlayerControllerAnnotated)
                      : Center(
                          child: CircularProgressIndicator(),
                        )),
            ),
            floatingActionButton: _videoIsLoading == true
                ? Center(
                    child: Container(),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerControllerAnnotated.value.isPlaying
                            ? _videoPlayerControllerAnnotated.pause()
                            : _videoPlayerControllerAnnotated.play();
                      });
                    },
                    child: Icon(
                      _videoPlayerControllerAnnotated.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
          )
        : Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Annotated video is being processed. Please check back later.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              Image.network(
                  "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExODc2YXBlNGYwNWUwMTMzbTF6cWZ4aTAydDY5YmF5aWdubnNwbTRlYiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/gf5UHCBpCgkz2X2wu0/giphy.gif"),
            ],
          );
  }

  Widget _buildStatBox(BuildContext context, String title, String subtitle) {
    return Expanded(
        child: Container(
      // width: MediaQuery.of(context).size.width / 5,
      // height: MediaQuery.of(context).size.width / 3,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Text(
          //   subtitle,
          //   style: const TextStyle(
          //     fontSize: 12,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
    ));
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
      contentPadding:
          const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
      title: Text(
        titleName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          // fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 123, 123, 123),
        ),
      ),
    ),
  );
}

Widget buildRatingContainer(context, rating, ratingName) {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 227, 227, 227),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            // width: 80,
            height: 60,

            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(20.0),
            //   bottomLeft: Radius.circular(20.0),
            // ),
            // gradient: LinearGradient(
            //   begin: Alignment.bottomCenter,
            //   end: Alignment.topCenter,
            //   colors: getRatingColors(rating),
            //   stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            // ),
            color: getRatingColors(rating)[0],

            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rating.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ratingName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
          )));
}
