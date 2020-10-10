import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxnews/screens/live.dart';
import 'package:provider/provider.dart';

import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'menu.dart';
import 'models/app.dart';
import 'models/blog_news.dart';
import 'models/category.dart';
import 'route.dart';
import 'screens/categories/index.dart';
import 'screens/home/home.dart';
import 'screens/post_screen.dart';
import 'screens/search/search.dart';
import 'screens/settings/notification.dart';
import 'screens/static_page.dart';
import 'screens/static_site.dart';
import 'screens/user.dart';
import 'screens/webview_screen.dart';
import 'screens/wishlist.dart';
import 'widgets/blog/horizontal/slider_list.dart';
import 'widgets/icons/feather.dart';
import 'widgets/layout/adaptive.dart';
import 'widgets/layout/layout_web.dart';
import 'widgets/onesignal/onesignal.dart';

class MainTabControlDelegate {
  int index;
  Function(String nameTab) changeTab;
  Function(int index) tabAnimateTo;

  static MainTabControlDelegate _instance;
  static MainTabControlDelegate getInstance() {
    return _instance ??= MainTabControlDelegate._();
  }

  MainTabControlDelegate._();
}

class MainTabs extends StatefulWidget {
  MainTabs({Key key}) : super(key: key);

  @override
  MainTabsState createState() => MainTabsState();
}

class MainTabsState extends State<MainTabs>
    with
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin,
        AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: close_sinks
  final StreamController<String> _controllerRouteWeb =
      StreamController<String>.broadcast();
  final _auth = FirebaseAuth.instance;

  InterstitialAd interstitialAd;
  FirebaseUser loggedInUser;
  int pageIndex = 0;
  int currentPage = 0;
  String currentTitle = "Home";
  Color currentColor = Colors.deepPurple;
  bool isAdmin = false;
  TabController tabController;
  Map saveIndexTab = Map();
  final List<Widget> _tabView = [];

  void afterFirstLayout(BuildContext context) {
    //trigger any event from click on one signal notification
    MyOneSignal().navigateToOneSignalItem(context);
    loadTabBar();
  }

  void changeTab(String nameTab) {
    tabController?.animateTo(saveIndexTab[nameTab] ?? 0);
  }

  Widget tabView(Map<String, dynamic> data) {
    switch (data['layout']) {
      case 'category':
        return CategoriesScreen(
          key: const Key("category"),
          layout: data['categoryLayout'],
          categories: data['categories'],
          images: data['images'],
        );
      case 'search':
        return SearchScreen();
      case 'profile':
        return UserScreen();
      case 'live':
        return Live();
      case 'blog':
        return HorizontalSliderList(config: data);
      case 'wishlist':
        return WishList();
      case 'page':
        return WebViewScreen(title: data['title'], url: data['url']);
      case 'html':
        return StaticSite(data: data['data']);
      case 'static':
        return StaticPage(data: data['data']);
      case 'postScreen':
        return PostScreen(
          pageId: data['pageId'],
          pageTitle: data['pageTitle'],
          isLocatedInTabbar: true,
        );
      case 'dynamic':
      default:
        return HomeScreen();
    }
  }

  List<Widget> renderTabbar() {
    final tabData = Provider.of<AppModel>(context).appConfig['TabBar'] as List;
    List<Widget> list = [];

    tabData.asMap().forEach((i, item) {
      var icon = !item["icon"].contains('/')
          ? Icon(
              featherIcons[item["icon"]],
              color: Colors.red,
              size: 22,
            )
          : (item["icon"].contains('http')
              ? Image.network(
                  item["icon"],
                  color: Colors.red,
                  width: 22,
                )
              : Image.asset(
                  item["icon"],
                  color: Colors.red,
                  width: 22,
                ));
      list.add(Tab(
        child: icon,
      ));
    });

    return list;
  }

  void loadTabBar() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;
    setState(() {
      tabController = TabController(length: tabData.length, vsync: this);
      currentPage = MainTabControlDelegate.getInstance().index ?? 0;
    });

    if (MainTabControlDelegate.getInstance().index != null) {
      tabController.animateTo(MainTabControlDelegate.getInstance().index);
    } else {
      MainTabControlDelegate.getInstance().index = 0;
    }

    tabController.addListener(() {
      eventBus.fire('tab_${tabController.index}');
      MainTabControlDelegate.getInstance().index = tabController.index;
    });

    for (var i = 0; i < tabData.length; i++) {
      setState(() {
        _tabView.add(tabView(Map.from(tabData[i])));
      });
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List getChildren(List<Category> categories, Category category) {
    List<Widget> list = [];
    var children = categories.where((o) => o.parent == category.id).toList();
    if (children.isEmpty) {
      list.add(
        ListTile(
          leading: Padding(
            child: Text(category.name),
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

  List showCategories() {
    final categories = Provider.of<CategoryModel>(context).categories;
    List<Widget> widgets = [];

    if (categories != null) {
      var list = categories.where((item) => item.parent == 0).toList();
      for (var index in list) {
        widgets.add(
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                index.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            children: getChildren(categories, index),
          ),
        );
      }
    }
    return widgets;
  }

  bool checkIsAdmin() {
    if (loggedInUser.email == adminEmail) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    return isAdmin;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      final appModel = Provider.of<AppModel>(context, listen: false);
      if (appModel.deeplink?.isNotEmpty ?? false) {
        if (appModel.deeplink['screen'] == 'NotificationScreen') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        }
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    getCurrentUser();
    MainTabControlDelegate.getInstance().changeTab = changeTab;
    MainTabControlDelegate.getInstance().tabAnimateTo = (int index) {
      tabController?.animateTo(index);
    };
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Widget renderBody(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (kLayoutWeb) {
      final isDesktop = isDisplayDesktop(context);

      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          // For desktop layout we do not want to have SafeArea at the top and
          // bottom to display 100% height content on the accounts view.
          top: !isDesktop,
          bottom: !isDesktop,
          child: Theme(
              // This theme effectively removes the default visual touch
              // feedback for tapping a tab, which is replaced with a custom
              // animation.
              data: theme.copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: LayoutWebCustom(
                menu: MenuBar(controllerRouteWeb: _controllerRouteWeb),
                content: StreamBuilder<String>(
                    initialData: "/home-screen",
                    stream: _controllerRouteWeb.stream,
                    builder: (context, snapshot) {
                      return Navigator(
                        key: Key(snapshot.data),
                        initialRoute: snapshot.data,
                        onGenerateRoute: (RouteSettings settings) {
                          return MaterialPageRoute(
                              builder: kRouteApp[settings.name] ??
                                  kRouteApp["/home-screen"],
                              settings: settings,
                              maintainState: false,
                              fullscreenDialog: true);
                        },
                      );
                    }),
              )),
        ),
      );
    } else {
      final screenSize = MediaQuery.of(context).size;
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: _tabView,
          ),
          drawer: Drawer(child: MenuBar()),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              width: screenSize.width,
              child: FittedBox(
                child: Container(
                  width: screenSize.width /
                      (2 / (screenSize.height / screenSize.width)),
                  child: TabBar(
                    controller: tabController,
                    tabs: renderTabbar(),
                    isScrollable: false,
                    labelColor: Theme.of(context).primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: const EdgeInsets.all(4.0),
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarWhiteForeground(false);
    if (_tabView.isEmpty) {
      return Container();
    }

    return renderBody(context);
  }
}
