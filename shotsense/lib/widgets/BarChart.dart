import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ShotsBarChart extends StatefulWidget {
  final Map<String, dynamic> ballsData;
  ShotsBarChart({required this.ballsData, super.key});

  final Color barBackgroundColor = Colors.grey.withOpacity(0.2);
  final Color barColor = Color.fromARGB(255, 205, 32, 109);
  final Color touchedBarColor = Color(0xff221D55);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<ShotsBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    print(widget.ballsData);
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // const Text(
                //   'Shots Played',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(
                  height: 4,
                ),
                // Text(
                //   '"]}',
                //   style: const TextStyle(
                //     color: Colors.black,
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(
                  height: 0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      // swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: IconButton(
          //       icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
          //           color: Colors.blueGrey),
          //       onPressed: () {
          //         setState(() {
          //           isPlaying = !isPlaying;
          //           if (isPlaying) {
          //             refreshState();
          //           }
          //         });
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 12,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.withOpacity(0.2))
              : const BorderSide(color: Colors.grey, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.ballsData["totalBalls"] -
                (widget.ballsData["totalBalls"] / 2)
                    .toDouble(), // TOTAL BALLS VARIABLE HERE
            color: Color.fromARGB(255, 102, 102, 102).withOpacity(0.2),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(8, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0, widget.ballsData["pullShotCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, widget.ballsData["hookCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(
                2, widget.ballsData["coverDriveCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(
                3, widget.ballsData["straightCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, widget.ballsData["defenceCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, widget.ballsData["flickCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, widget.ballsData["sweepCount"].toDouble(),
                isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(7, widget.ballsData["cutCount"].toDouble(),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          // getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -7,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String shotType;
            switch (group.x) {
              case 0:
                shotType = 'Pull';
                break;
              case 1:
                shotType = 'Hook';
                break;
              case 2:
                shotType = 'Cover Drive';
                break;
              case 3:
                shotType = 'Straight Drive';
                break;
              case 4:
                shotType = 'Defence';
                break;
              case 5:
                shotType = 'Flick';
                break;
              case 6:
                shotType = 'Sweep';
                break;
              case 7:
                shotType = 'Cut';
                break;

              default:
                throw Error();
            }
            return BarTooltipItem(
              '$shotType\n',
              const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toStringAsFixed(0) + ' shots',
                  style: const TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255), //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            // getTitlesWidget: getTitles,
            reservedSize: 20,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Pull', style: style);
        break;
      case 1:
        text = const Text('Cover', style: style);
        break;
      case 2:
        text = const Text('Straight', style: style);
        break;
      case 3:
        text = const Text('Defence', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  // BarChartData randomData() {
  //   return BarChartData(
  //     barTouchData: BarTouchData(
  //       enabled: false,
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: getTitles,
  //           reservedSize: 38,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //       topTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //       rightTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: false,
  //     ),
  //     barGroups: List.generate(7, (i) {
  //       switch (i) {
  //         case 0:
  //           return makeGroupData(
  //             0,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 1:
  //           return makeGroupData(
  //             1,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 2:
  //           return makeGroupData(
  //             2,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 3:
  //           return makeGroupData(
  //             3,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 4:
  //           return makeGroupData(
  //             4,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 5:
  //           return makeGroupData(
  //             5,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         case 6:
  //           return makeGroupData(
  //             6,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: Colors.amber,
  //           );
  //         default:
  //           return throw Error();
  //       }
  //     }),
  //     gridData: FlGridData(show: false),
  //   );
  // }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
