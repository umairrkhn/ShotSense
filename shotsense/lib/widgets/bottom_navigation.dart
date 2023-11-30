import 'package:flutter/material.dart';
import 'package:shotsense/screens/settings.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              // Navigator.pushNamed(context, '/record');
              print("record page");
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Shots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
