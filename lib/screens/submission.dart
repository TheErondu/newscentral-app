import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class Submission extends StatefulWidget {
  @override
  _SubmissionState createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  String url = "";
  double progress = 0;

  // @override

// // ignore: must_call_super
//   void initState() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   // ignore: must_call_super
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text('Speak Your Mind'),
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
                initialUrl: "https://newscentral.africa/speak-your-mind",
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: false,
                )),
                onWebViewCreated: (InAppWebViewController controller) {},
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
