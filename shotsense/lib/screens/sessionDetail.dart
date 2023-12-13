import 'package:flutter/material.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/sessionDetail';
  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Detail'),
      ),
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
                    width: 172,
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
                    width: 172,
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Over 4",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 11, 11, 11))),
                            Icon(Icons.arrow_drop_down_rounded, size: 50),
                            SizedBox(width: 200),
                            Icon(
                              Icons.add_circle,
                              size: 35,
                              color: Color.fromARGB(255, 21, 101, 167),
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
                      child: const Center(
                        child: Text(
                          '1.1',
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
                      child: const Center(
                        child: Text(
                          '1.2',
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
                                "Square cut to a wide delivery",
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
                                  "Square Cut Shot",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(187, 21, 30, 35)),
                                ),
                              ],
                            )
                          ],
                        ))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
