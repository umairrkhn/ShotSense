import 'package:flutter/material.dart';
import 'package:shotsense/widgets/custom_appBar.dart';

// ignore: must_be_immutable
class ShotTypeStats extends StatefulWidget {
  Map<String, dynamic> sessionStats;
  ShotTypeStats({Key? key, required this.sessionStats}) : super(key: key);
  static const routeName = '/shotTypeStats';
  @override
  ShotTypeStatsScreen createState() => ShotTypeStatsScreen();
}

class ShotTypeStatsScreen extends State<ShotTypeStats> {
  @override
  void initState() {
    super.initState();
    print(widget.sessionStats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Shot Type Stats"),
      body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            buildListItem(context, "Cover Drive",
                "${(widget.sessionStats['coverDriveCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Cut",
                "${(widget.sessionStats['cutCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Defence",
                "${(widget.sessionStats['defenceCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Flick",
                "${(widget.sessionStats['flickCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Hook",
                "${(widget.sessionStats['hookCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Pull",
                "${(widget.sessionStats['pullShotCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Straight",
                "${(widget.sessionStats['straightCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            buildListItem(context, "Sweep",
                "${(widget.sessionStats['sweepCount'] / widget.sessionStats['totalBalls'] * 100).toString()}%"),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            buildListItem(context, "Total Balls",
                widget.sessionStats['totalBalls'].toString()),
            buildListItem(context, "Highest Shot Type",
                widget.sessionStats['highestShotType'].toString()),
          ]))),
    );
  }
}

Widget buildListItem(BuildContext context, String title, String value) {
  return ListTile(
    title: Text(title, style: const TextStyle(fontSize: 20)),
    trailing: Text(value, style: const TextStyle(fontSize: 20)),
  );
}
