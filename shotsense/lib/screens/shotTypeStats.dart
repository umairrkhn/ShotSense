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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Shot Type Stats"),
      body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            widget.sessionStats['coverDriveCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Cover Drive",
                        "${(widget.sessionStats['coverDriveCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['cutCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Cut Shot",
                        "${(widget.sessionStats['cutCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['defenceCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Defence",
                        "${(widget.sessionStats['defenceCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['flickCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Flick Shot",
                        "${(widget.sessionStats['flickCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['hookCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Hook Shot",
                        "${(widget.sessionStats['hookCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['pullShotCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Pull Shot",
                        "${(widget.sessionStats['pullShotCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['straightCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Straight Drive",
                        "${(widget.sessionStats['straightCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            widget.sessionStats['sweepCount'] > 0
                ? Column(children: [
                    buildListItem(context, "Sweep",
                        "${(widget.sessionStats['sweepCount'] / widget.sessionStats['totalBalls'] * 100).toStringAsFixed(1)}%"),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ])
                : Container(),
            buildListItem(context, "Total shots Played",
                widget.sessionStats['totalBalls'].toString()),
            buildListItem(context, "Most played type",
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
