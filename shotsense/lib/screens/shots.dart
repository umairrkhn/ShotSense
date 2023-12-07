import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shotsense/widgets/bottom_navigation.dart';

class ShotScreen extends StatelessWidget {
  const ShotScreen({Key? key}) : super(key: key);
  static const routeName = '/shots';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 8),
              Text('Shots',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      )),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              iconSize: 32,
            ),
          ],
        ),
        // appBar: CustomAppBar(), // later for adding a custom app bar
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cover Drive',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              // color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            )),
                    FaIcon(FontAwesomeIcons.filter, size: 28),
                  ],
                ),
                SizedBox(height: 8.0),
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
                              title: Text('11-04-22'),
                              subtitle: Text('0:13'),
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
                              title: Text('11-04-22'),
                              subtitle: Text('0:15'),
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
                              title: Text('08-04-22'),
                              subtitle: Text('0:06'),
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
        ));
  }
}
