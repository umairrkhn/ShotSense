import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import 'package:shotsense/services/flutter-firebase-auth.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

class SingleBallPage extends StatelessWidget {
  const SingleBallPage({Key? key}) : super(key: key);
  static const routeName = '/singleBall';

  void signout(BuildContext context) async {
    await context.read<FirebaseAuthMethods>().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ball 1/6"),
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
              child: const ListTile(
                contentPadding: EdgeInsets.only(
                  top: 6,
                  bottom: 0,
                  left: 20,
                  right: 20,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From the session',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 71, 71, 71),
                      ),
                    ),
                    Text(
                      'Batting Training',
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
                      '12th Nov 2023',
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
            ),
            const SizedBox(height: 15.0),
            Container(
              height: 200,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatBox(context, "Ball Hit", "Ball Hit/Miss"),
                  _buildStatBox(context, "Sweep", "Shot Type"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final VideoPlayerController videoPlayerController =
        VideoPlayerController.asset(
      'assets/videos/pull_04.mp4',
      package: 'video_player',
    );

    final ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      // autoPlay: true,
      // looping: true,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    return Chewie(controller: chewieController);
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
