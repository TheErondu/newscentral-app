import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluxnews/screens/submission.dart';
import 'package:fluxnews/screens/videos_list_screen.dart';
import 'package:provider/provider.dart';

import 'common/config.dart';
import 'generated/l10n.dart';
import 'models/app.dart';
import 'models/blog_news.dart';
import 'models/category.dart';
import 'models/user.dart';
import 'screens/live.dart';
import 'screens/post_screen.dart';

class MenuBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigation;
  final StreamController<String> controllerRouteWeb;

  MenuBar({this.navigation, this.controllerRouteWeb});

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  Widget imageContainer(String link) {
    ;
    if (link.contains('http://') || link.contains('https://')) {
      return Image.network(
        link,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      link,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget drawerItem(item) {
    if (!item['show']) return Container();
    switch (item['type']) {
      case 'home':
        {
          return ListTile(
            leading: const Icon(
              Icons.home,
              size: 25,
            ),
            title: Text(
              S.of(context).home,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              if (kLayoutWeb) {
                widget.controllerRouteWeb.sink.add("/home-screen");
              } else {
                Navigator.of(context).pushReplacementNamed("/home");
              }
            },
          );
        }

      case 'live':
        {
          return ListTile(
            leading: const Icon(
              Icons.live_tv,
              size: 25,
              color: Colors.red,
            ),
            title: Text(
              S.of(context).live,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Live(),
                ),
              );
            },
          );
        }
      case 'web':
        {
          return ListTile(
            leading: const Icon(
              Icons.play_circle_outline,
              size: 25,
              color: Colors.blue,
            ),
            title: Text(
              S.of(context).webView,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideosScreen(),
                ),
              );
            },
          );
        }
      case 'about':
        {
          return ListTile(
            leading: const Icon(
              Icons.chat_bubble_outline,
              size: 25,
            ),
            title: Text(
              S.of(context).aboutUs,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(
                    pageId: 2833,
                    pageTitle: S.of(context).aboutUs.toString(),
                  ),
                ),
              );
            },
          );
        }
      case 'submissions':
        {
          return ListTile(
            leading: const Icon(
              Icons.info_outline,
              size: 25,
            ),
            title: Text(S.of(context).submissions),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Submission(),
                ),
              );
            },
          );
        }
      case 'login':
        {
          bool loggedIn =
              Provider.of<UserModel>(context, listen: false).loggedIn;

          return ListTile(
            leading: const Icon(Icons.exit_to_app, size: 20),
            title: loggedIn
                ? Text(S.of(context).logout)
                : Text(S.of(context).login),
            onTap: () {
              loggedIn
                  ? Provider.of<UserModel>(context, listen: false).logout()
                  : Navigator.pushNamed(context, "/login");
            },
          );
        }
      case 'category':
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  S.of(context).byCategory.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor.withOpacity(0.5),
                  ),
                ),
                children: showCategories(),
              )
            ],
          );
        }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> drawer =
        Provider.of<AppModel>(context, listen: false).drawer ?? kDefaultDrawer;

    return SingleChildScrollView(
      key: drawer['key'] != null ? Key(drawer['key']) : null,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                if (drawer['background'] != null)
                  Container(
                    child: imageContainer(drawer['background']),
                  ),
                if (drawer['logo'] != null)
                  Align(
                    alignment: const Alignment(-0.8, 0.6),
                    child: Container(
                      height: double.infinity,
                      child: imageContainer(drawer['logo']),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              children: List.generate(drawer['items'].length, (index) {
                return drawerItem(drawer['items'][index]);
              }),
            ),
          )
        ],
      ),
    );
  }

  List showCategories() {
    final categories =
        Provider.of<CategoryModel>(context, listen: false).categories;
    List<Widget> widgets = [];

    if (categories != null) {
      var list = categories.where((item) => item.parent == 0).toList();
      for (var index in list) {
        widgets.add(
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 0),
              child: Text(
                index.name.toUpperCase(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            children: getChildren(categories, index),
          ),
        );
      }
    }
    return widgets;
  }

  List getChildren(List<Category> categories, Category category) {
    List<Widget> list = [];
    var children = categories.where((o) => o.parent == category.id).toList();

    if (children.isEmpty) {
      list.add(
        ListTile(
          leading: Padding(
            child: const Text('Click to Read Stories.'),
            padding: const EdgeInsets.only(left: 20),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
          onTap: () {
            BlogNews.showList(
                context: context, cateId: category.id, cateName: category.name);
          },
        ),
      );
    }
    for (var i in children) {
      list.add(
        ListTile(
          leading: Padding(
            child: Text(i.name),
            padding: const EdgeInsets.only(left: 20),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
          onTap: () {
            BlogNews.showList(context: context, cateId: i.id, cateName: i.name);
          },
        ),
      );
    }
    return list;
  }
}
