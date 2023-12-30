import 'package:flutter/material.dart';
import 'package:shotsense/screens/addOver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shotsense/widgets/custom_appBar.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/sessionDetail';
  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  File? _video;
  final ImagePicker _imagePicker = ImagePicker();
  late VideoPlayerController _videoPlayerController;
  List<VideoPlayerController> _videoPlayerControllers = [];

  // Future<void> _getImageFromCamera() async {
  //   final pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
    }
  }

  Future _recordVideo() async {
    final pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _video = File(pickedFile.path);
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Video'),
                content: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      setState(() {
                        _videoPlayerController.pause();
                        _videoPlayerControllers.add(_videoPlayerController);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
    }
  }

  Future _pickVideo() async {
    final pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _video = File(pickedFile.path);
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Video'),
                content: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      // Add the controller to the list and start playing
                      setState(() {
                        // _videoPlayerController.setLooping(true);
                        // _videoPlayerController.play();

                        _videoPlayerControllers.add(_videoPlayerController);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take a video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Choose from gallery'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Session Details"),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0xFFF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15.0),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: const ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 6, bottom: 0, left: 20, right: 20),

                  // leading: ClipRRect(
                  //   borderRadius: BorderRadius.circular(8.0),
                  // ),
                  title: Text(
                    'Batting Training',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  subtitle: Text('12th Nov 2023',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 123, 123, 123))),
                )),
            const SizedBox(height: 15.0),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    // width: 172,
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
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "84%",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Ball hit Accuracy",
                          style: TextStyle(
                              // fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )),
                Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 190,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Cover Drive",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Frequent Shot Type",
                          style: TextStyle(
                              // fontSize: 30,

                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )),
              ],
            )),
            Column(
              // the over section
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                Row(
                  children: [
                    InkWell(
                        onTap: () => {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Over 4",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 11, 11, 11))),
                            const Icon(Icons.arrow_drop_down_rounded, size: 50),
                            const SizedBox(width: 200),
                            GestureDetector(
                              onTap: () => {
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) {
                                //     return const AddOver();
                                //   },
                                // ))
                                _showImagePickerBottomSheet()
                              },
                              child: const Icon(
                                Icons.add_circle,
                                size: 35,
                                color: Color.fromARGB(255, 21, 101, 167),
                              ),
                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
            SizedBox(height: 15.0),
            Column(
              // Balls in the over section
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var videoPlayerController
                    in _videoPlayerControllers.asMap().entries)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
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
                            _videoPlayerControllers
                                .asMap()
                                .entries
                                .map((entry) => "${entry.key + 1}")
                                .join(" "),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 280,
                                child: const Text(
                                  "Backward defense against a turning delivery",
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "May 1 2022",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(187, 21, 30, 35)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "•",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(187, 21, 30, 35)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Defense Shot",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(187, 21, 30, 35)),
                                  ),
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                SizedBox(height: 15.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
