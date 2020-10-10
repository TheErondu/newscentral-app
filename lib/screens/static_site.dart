import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticSite extends StatelessWidget {
  final String data;

  StaticSite({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Platform.isMacOS || Platform.isWindows || Platform.isFuchsia
          ? const Center(
              child: Text('This platform is not supported for webview'),
            )
          : WebView(
              onWebViewCreated: (controller) async {
                final String contentBase64 =
                    base64Encode(const Utf8Encoder().convert(data));
                await controller
                    .loadUrl('data:text/html;base64,$contentBase64');
              },
            ),
    );
  }
}
