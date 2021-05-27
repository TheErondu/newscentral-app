import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  @override

// ignore: must_call_super
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // ignore: must_call_super
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('News Central Live'),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Container(
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: InAppWebView(
                initialUrl:
                    "http://41.203.80.250/hls/live.m3u8",
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: false,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  setState(() {
                    this.url = url;
                  });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
