import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../common/constants.dart';
import '../common/styles.dart';
import '../generated/l10n.dart';
import '../models/app.dart';
import '../models/user.dart';
import '../models/wishlist.dart';
import '../screens/post_management/post_management.dart';
import '../screens/post_screen.dart';
import '../widgets/common/smartchat.dart';
import 'language.dart';
import 'notification.dart';

class SettingScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  SettingScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        AfterLayoutMixin,
        AutomaticKeepAliveClientMixin<SettingScreen> {
  final bannerHigh = 200.0;
  bool enabledNotification = true;
  bool isAbleToPostManagement = false;
  final RateMyApp _rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
  );
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.user != null) checkAddPostRole();
  }

  void checkNotificationPermission() async {
    try {
      await NotificationPermissions.getNotificationPermissionStatus()
          .then((status) {
        if (mounted) {
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
        }
      });
    } catch (err) {
//      print(err);
    }
  }

  void checkAddPostRole() {
    for (String legitRole in addPostAccessibleRoles) {
      if (widget.user.role == legitRole) {
        setState(() {
          isAbleToPostManagement = true;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final wishListCount =
        Provider.of<WishListModel>(context, listen: false).blogs.length;
    bool loggedIn = Provider.of<UserModel>(context).loggedIn;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: SmartChat(user: widget.user),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black87,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            expandedHeight: bannerHigh,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                // title: Text(S.of(context).settings,
                //     style: const TextStyle(
                //         fontSize: 18,
                //         color: Colors.black87,
                //         fontWeight: FontWeight.w600)),
                background: Image.asset(
              settingsBackground,
              fit: BoxFit.cover,
            )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (widget.user != null && widget.user.name != null)
                        ListTile(
                          leading: widget.user.picture != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.user.picture))
                              : const Icon(Icons.face),
                          title: Text(
                              widget.user.name.replaceAll("fluxstore", ""),
                              style: const TextStyle(fontSize: 16)),
                        ),
                      if (widget.user != null && widget.user.email != null)
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(widget.user.email,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      // if (widget.user == null)
                      //   Card(
                      //     color: Theme.of(context).backgroundColor,
                      //     margin: const EdgeInsets.only(bottom: 2.0),
                      //     elevation: 0,
                      //     child: ListTile(
                      //       onTap: () {
                      //         if (loggedIn) {
                      //           Provider.of<UserModel>(context, listen: false)
                      //               .logout();
                      //         } else {
                      //           Navigator.pushNamed(context, "/login");
                      //         }
                      //       },
                      //       leading: const Icon(Icons.person),
                      //       title: Text(
                      //         loggedIn
                      //             ? S.of(context).logout
                      //             : S.of(context).login,
                      //         style: const TextStyle(fontSize: 16),
                      //       ),
                      //       trailing: const Icon(Icons.arrow_forward_ios,
                      //           size: 18, color: kGrey600),
                      //     ),
                      //   ),
                      // if (widget.user != null)
                      //   Card(
                      //     color: Theme.of(context).backgroundColor,
                      //     margin: const EdgeInsets.only(bottom: 2.0),
                      //     elevation: 0,
                      //     child: ListTile(
                      //       onTap: widget.onLogout,
                      //       leading: Image.asset(
                      //         'assets/icons/profile/icon-logout.png',
                      //         width: 24,
                      //         color: Theme.of(context).accentColor,
                      //       ),
                      //       title: Text(S.of(context).logout,
                      //           style: const TextStyle(fontSize: 16)),
                      //       trailing: const Icon(Icons.arrow_forward_ios,
                      //           size: 18, color: kGrey600),
                      //     ),
                      //   ),
                      const SizedBox(height: 30.0),
                      Text(S.of(context).generalSetting,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10.0),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/profile/icon-heart.png',
                            width: 20,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text(S.of(context).myWishList,
                              style: const TextStyle(fontSize: 15)),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            if (wishListCount > 0)
                              Text(
                                "$wishListCount ${S.of(context).items}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor),
                              ),
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward_ios,
                                size: 18, color: kGrey600)
                          ]),
                          onTap: () {
                            Navigator.pushNamed(context, "/wishlist");
                          },
                        ),
                      ),
//                      Divider(
//                        color: Colors.black12,
//                        height: 1.0,
//                        indent: 75,
//                        //endIndent: 20,
//                      ),
                      isAbleToPostManagement
                          ? Card(
                              margin: const EdgeInsets.only(bottom: 2.0),
                              elevation: 0,
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/icons/tabs/icon-cart2.png',
                                  width: 20,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(S.of(context).postManagement,
                                    style: const TextStyle(fontSize: 15)),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.arrow_forward_ios,
                                          size: 18, color: kGrey600)
                                    ]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostManagementScreen(),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      isAbleToPostManagement
                          ? const Divider(
                              color: Colors.black12,
                              height: 1.0,
                              indent: 75,
                              //endIndent: 20,
                            )
                          : Container(),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: SwitchListTile(
                          secondary: Image.asset(
                            'assets/icons/profile/icon-notify.png',
                            width: 25,
                            color: Theme.of(context).accentColor,
                          ),
                          value: enabledNotification,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (bool value) {
                            if (value) {
                              NotificationSettingsIos iosSetting =
                                  const NotificationSettingsIos(
                                      sound: true, badge: true, alert: true);
                              NotificationPermissions
                                      .requestNotificationPermissions(
                                          iosSettings: iosSetting)
                                  .then((_) {
                                checkNotificationPermission();
                              });
                            }
                            setState(() {
                              enabledNotification = value;
                            });
                          },
                          title: Text(
                            S.of(context).getNotification,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      enabledNotification
                          ? Card(
                              margin: const EdgeInsets.only(bottom: 2.0),
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Notifications()));
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.list,
                                    size: 24,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  title: Text(S.of(context).listMessages),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: kGrey600,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      enabledNotification
                          ? const Divider(
                              color: Colors.black12,
                              height: 1.0,
                              indent: 75,
                              //endIndent: 20,
                            )
                          : Container(),
                      const Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Language()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.language,
                              color: Theme.of(context).accentColor,
                              size: 24,
                            ),
                            title: Text(S.of(context).language),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: kGrey600,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: SwitchListTile(
                          secondary: Icon(
                            Icons.dashboard,
                            color: Theme.of(context).accentColor,
                            size: 24,
                          ),
                          value: Provider.of<AppModel>(context, listen: false)
                              .darkTheme,
                          activeColor: const Color(0xFF0066B4),
                          onChanged: (bool value) {
                            if (value) {
                              Provider.of<AppModel>(context, listen: false)
                                  .updateTheme(true);
                            } else {
                              Provider.of<AppModel>(context, listen: false)
                                  .updateTheme(false);
                            }
                          },
                          title: Text(
                            S.of(context).darkTheme,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            _rateMyApp
                                .showRateDialog(context)
                                .then((v) => setState(() {}));
                          },
                          leading: Image.asset(
                            'assets/icons/profile/icon-star.png',
                            width: 24,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text(S.of(context).rateTheApp,
                              style: const TextStyle(fontSize: 16)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 18, color: kGrey600),
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(
                            Icons.report,
                            size: 20,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text(
                            '${S.of(context).privacyPolicy.toString()}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward_ios,
                                size: 18, color: kGrey600),
                          ]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostScreen(
                                  pageId: 3,
                                  pageTitle:
                                      S.of(context).privacyPolicy.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // const Divider(
                      //   color: Colors.black12,
                      //   height: 1.0,
                      //   indent: 75,
                      //   //endIndent: 20,
                      // ),
                      // Card(
                      //   margin: const EdgeInsets.only(bottom: 2.0),
                      //   elevation: 0,
                      //   child: ListTile(
                      //     leading: Icon(
                      //       Icons.contacts,
                      //       size: 20,
                      //       color: Theme.of(context).accentColor,
                      //     ),
                      //     title: Text(
                      //       '${S.of(context).contact.toString()}',
                      //       style: const TextStyle(fontSize: 15),
                      //     ),
                      //     trailing:
                      //         Row(mainAxisSize: MainAxisSize.min, children: [
                      //       const SizedBox(width: 5),
                      //       const Icon(Icons.arrow_forward_ios,
                      //           size: 18, color: kGrey600),
                      //     ]),
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => PostScreen(
                      //             pageId: 775,
                      //             pageTitle: S.of(context).contact.toString(),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
