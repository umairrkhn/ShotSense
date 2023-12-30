import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Navigator.canPop(context) ? Color(0xFFF5F5F5) : Colors.transparent,
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
              : MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
