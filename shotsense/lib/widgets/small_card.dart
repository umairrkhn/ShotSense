import 'package:flutter/material.dart';
import 'package:shotsense/screens/sessionDetail.dart';

class smallCard extends StatefulWidget {
  final String name;
  final String date;

  const smallCard({Key? key, required this.name, required this.date})
      : super(key: key);

  @override
  _smallCardState createState() => _smallCardState();
}

class _smallCardState extends State<smallCard> {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              color: Colors.white,
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SessionDetailScreen();
                  },
                ));
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/ShotSense-logo.png',
                  width: 80,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(widget.name),
              subtitle: Text(widget.date),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
