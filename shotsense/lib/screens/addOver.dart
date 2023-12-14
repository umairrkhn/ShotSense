import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shotsense/utils/showSnackbar.dart';
import 'package:video_player/video_player.dart';

class AddOver extends StatefulWidget {
  const AddOver({Key? key}) : super(key: key);

  @override
  _AddOverState createState() => _AddOverState();
}

class _AddOverState extends State<AddOver> {
  final _picker = ImagePicker();
  late List<VideoPlayerController> _videoPlayerController = [];
  File? _video;

  Future _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
        _videoPlayerController.add(
          VideoPlayerController.file(_video!)
            ..initialize()
            ..setLooping(true),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Over'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Over 4",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 11, 11, 11),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickVideo();
                  },
                  child: const Icon(
                    Icons.add_circle,
                    size: 35,
                    color: Color.fromARGB(255, 21, 101, 167),
                  ),
                ),
              ],
            ),
          ),
          if (_video != null)
            SingleChildScrollView(
                child: Container(
              height: 520,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(_videoPlayerController.length, (index) {
                  return ListTile(
                    title: Container(
                      padding: EdgeInsets.all(10),
                      height: 300,
                      width: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: VideoPlayer(_videoPlayerController[index]),
                      ),
                    ),
                  );
                }),
              ),
            )),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              color: Color(0xFF69A3F2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Add button logic here
                if (_videoPlayerController.length < 6) {
                  showSnackBar(context, "Over must have 6 videos");
                }
              },
              child: Text(
                'Add',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
