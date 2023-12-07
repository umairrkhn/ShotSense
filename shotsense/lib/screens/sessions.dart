import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key}) : super(key: key);
  static const routeName = '/sessions';

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: Center(
        child: const Text('Add your text here'),
      ),
    );
  }
}
