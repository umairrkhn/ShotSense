import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? isgettingInferece;

  const CustomAppBar({super.key, required this.title, this.isgettingInferece});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Color.fromARGB(255, 237, 36, 126),
            //     Color.fromARGB(255, 34, 29, 85),
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Navigator.canPop(context)
              ? Container(
                  padding: const EdgeInsets.only(top: 16.0, left: 15),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color.fromARGB(255, 29, 20, 118)),
                    iconSize: 26,
                    onPressed: () {
                      if (isgettingInferece == "true") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please wait for the inference to complete'),
                          ),
                        );
                      }
                      // trying of click only once and preventing twice new page opening
                      // else if (title == "Ball Details") {
                      //   print("poping from ball details");
                      //   Navigator.pop(context, "result");
                      // }
                      else {
                        Navigator.of(context).pop();
                      }
                    },
                  ))
              : (title == 'ShotSense')
                  ? Container(
                      padding: const EdgeInsets.only(top: 18, left: 20),
                      child: Image.asset(
                        'assets/images/ShotSense-logo.png', // Replace with your image path
                        width: 16,
                        height: 16,
                      ))
                  : null,
          title: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: Navigator.canPop(context)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: title == "Session Details"
                        ? 34
                        : title == "Shot Type Stats"
                            ? 30
                            : 38,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(208, 237, 36, 126),
                          Color.fromARGB(205, 34, 29, 85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
