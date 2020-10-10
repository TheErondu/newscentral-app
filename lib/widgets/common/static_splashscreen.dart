import 'package:flutter/material.dart';

import '../../common/tools.dart';

class StaticSplashScreen extends StatefulWidget {
  final String imagePath;
  final Key key;
  StaticSplashScreen({this.imagePath, this.key});

  @override
  _StaticSplashScreenState createState() => _StaticSplashScreenState();
}

class _StaticSplashScreenState extends State<StaticSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: widget.imagePath.startsWith('http')
            ? Tools.image(
                url: widget.imagePath,
                fit: BoxFit.cover,
              )
            : Image.asset(widget.imagePath,
                gaplessPlayback: true, fit: BoxFit.fill),
      ),
    );
  }
}
