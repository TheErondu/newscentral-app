import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../models/blog_news.dart';
import '../services/wordpress.dart';

class PostScreen extends StatefulWidget {
  final int pageId;
  final String pageTitle;
  final bool isLocatedInTabbar;
  PostScreen({this.pageId, this.pageTitle, this.isLocatedInTabbar = false});
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final WordPress _service = WordPress();
  Future<BlogNews> _getPage;
  final _memoizer = AsyncMemoizer<BlogNews>();
  @override
  void initState() {
    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getPage = getPageById(context);
      });
    });
    super.initState();
  }

  Future<BlogNews> getPageById(context) => _memoizer.runOnce(
        () => _service.getPageById(
          widget.pageId,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          '${widget.pageTitle.toString()}',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: widget.isLocatedInTabbar
            ? Container()
            : Center(
                child: GestureDetector(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
      ),
      body: SafeArea(
        child: FutureBuilder<BlogNews>(
          future: _getPage,
          builder: (BuildContext context, AsyncSnapshot<BlogNews> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Scaffold(
                  body: Container(
                    color: Theme.of(context).backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError || snapshot.data.id == null) {
                  return Material(
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Opps, this page seems no longer exist!',
                            style: TextStyle(color: Colors.black),
                          ),
                          widget.isLocatedInTabbar
                              ? Container()
                              : FlatButton(
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  },
                                  child: const Text(
                                    "Go back to home page",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                }

                return PostView(
                  item: snapshot.data,
                );
            }
          },
        ),
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final BlogNews item;
  PostView({this.item});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HtmlWidget(
            item.content,
            webView: true,
            webViewJs: true,
            hyperlinkColor: Theme.of(context).primaryColor.withOpacity(0.9),
            textStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 13.0,
                  height: 1.4,
                  color: Theme.of(context).accentColor,
                ),
          ),
        ],
      ),
    );
  }
}
