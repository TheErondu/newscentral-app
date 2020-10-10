import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'settings.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with AutomaticKeepAliveClientMixin<UserScreen> {
  final _auth = FirebaseAuth.instance;
  final _ggSignin = GoogleSignIn();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userModel = Provider.of<UserModel>(context, listen: true);
    return ListenableProvider.value(
      value: userModel,
      child: Consumer<UserModel>(builder: (context, value, child) {
        return SettingScreen(
          user: value.user,
          onLogout: () async {
            await userModel.logout();
            await _auth.signOut();
            await _ggSignin.signOut();
          },
        );
//          return LoginScreen();
      }),
    );
  }
}
