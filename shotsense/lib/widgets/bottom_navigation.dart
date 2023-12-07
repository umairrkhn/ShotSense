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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              if (index != _currentIndex) {
                Navigator.pushNamed(context, '/');
              }
              break;
            case 1:
              Navigator.pushNamed(context, '/sessions');
              print("Session page");
              break;
            case 2:
              // Navigator.pushNamed(context, '/shots');
              print("Shots page");
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Shots',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
