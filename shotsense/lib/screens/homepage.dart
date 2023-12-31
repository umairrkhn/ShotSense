import 'package:flutter/material.dart';
import '../widgets/custom_appBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'ShotSense',
        ),
        // later for adding a custom app bar
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15.0),
                        const Text("Welcome Back, Fahad!",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff221D55))),
                        const SizedBox(height: 15.0),
                        const Text("Overall Stats",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 79, 79, 79))),
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
                              // leading: ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              title: Text('Most Frequent Shot Played',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 123, 123, 123))),
                              subtitle: Text(
                                'Cover Drive',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 79, 79, 79)),
                              )),
                        ),
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
                              // leading: ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              title: Text('Overall Accuracy',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 123, 123, 123))),
                              subtitle: Text(
                                '84%',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 79, 79, 79)),
                              )),
                        ),
                        const SizedBox(height: 15.0),
                        const Text("Previous Session Played",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 79, 79, 79))),

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
                          child: Column(
                            children: [
                              const SizedBox(height: 5.0),
                              const ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: Text('Most Frequent Shot Played',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: Text('Cover Drive',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        Color.fromARGB(255, 79, 79, 79))),
                              ),
                              ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: const Text('Balls Hit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: '35/43 ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                            Color.fromARGB(255, 79, 79, 79),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'balls hit',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 79, 79, 79),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // add one for the date
                              const ListTile(
                                // leading: ClipRRect(
                                //   child: Text('1'),
                                // ),
                                title: Text('Date',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 123, 123, 123))),
                                subtitle: Text(
                                  '11/04/2023',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 79, 79, 79),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
