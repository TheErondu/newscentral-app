import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class AdSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 15.0, top: 40.0, right: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          HtmlWidget(
            'Hello World',
            webView: true,
          ),
        ],
      ),
    );
  }
}