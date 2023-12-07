import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

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
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ElevatedButton(
              onPressed: null,
              child: Text(
                  'Create New Session',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
            ),
            const Text('Previous Sessions', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/ShotSense-logo.png',
                              width: 80,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: const Text('Session 1'),
                          subtitle: const Text('2nd Nov 2023'),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/ShotSense-logo.png',
                              width: 80,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text('Session 2'),
                          subtitle: Text('10th Nov 2023'),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/ShotSense-logo.png',
                              width: 80,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text('Session 3'),
                          subtitle: Text('4th Dec 2023'),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}