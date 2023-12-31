import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

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
              ? Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    iconSize: 26,
                    onPressed: () => Navigator.of(context).pop(),
                  ))
              : null,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: Navigator.canPop(context)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Color.fromARGB(208, 237, 36, 126),
                      Color.fromARGB(205, 34, 29, 85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
