import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shotsense/screens/singleBall.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

class ShotScreen extends StatefulWidget {
  const ShotScreen({Key? key}) : super(key: key);
  static const routeName = '/shots';

  @override
  _ShotScreenState createState() => _ShotScreenState();
}

class _ShotScreenState extends State<ShotScreen> {
  String selectedShotType = 'Cover Drive';

  List<String> shotTypes = [
    'Cover Drive',
    'Straight',
    'Defence',
    'Hook',
    'Pull',
    'Cut',
    'Sweep',
    'Flick',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Shots"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedShotType,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 38, 5, 116),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showShotTypeDropdown(context);
                      },
                      child: const FaIcon(FontAwesomeIcons.filter, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
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
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const SingleBallPage();
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
                              title: const Text('11-04-22'),
                              subtitle: const Text('0:13'),
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
                                  offset: const Offset(0, 2),
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
                              title: const Text('11-04-22'),
                              subtitle: const Text('0:15'),
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
                                  offset: const Offset(0, 2),
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
                              title: const Text('08-04-22'),
                              subtitle: const Text('0:06'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
  void _showShotTypeDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Shot Type',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: shotTypes.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        shotTypes[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        setState(() {
                          selectedShotType = shotTypes[index];
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


