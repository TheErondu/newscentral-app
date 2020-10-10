import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app.dart';
import '../models/user.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String firstName, lastName, username, password;
  final TextEditingController _usernameController = TextEditingController();
  bool isChecked = false;

  void _welcomeDiaLog(User user) {
    var email = user.email;
    _snackBar('Welcome $email!');
    Provider.of<AppModel>(context, listen: false).isAccessedByOnBoardingBoard
        ? Navigator.pushNamed(context, '/home')
        : Navigator.of(context).pop();
  }

  void _failMess(message) {
    _snackBar(message);
  }

  void _snackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _submitRegister(firstName, lastName, username, password) {
      if (firstName == null ||
          lastName == null ||
          username == null ||
          password == null) {
        _snackBar('Please input fill in all fields');
      } else if (isChecked == false) {
        _snackBar('Please agree with our terms');
      } else {
        Provider.of<UserModel>(context, listen: false).createUser(
            username: username,
            password: password,
            firstName: firstName,
            lastName: lastName,
            success: _welcomeDiaLog,
            fail: _failMess);
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushNamed('/home');
                }
              }),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
        ),
        body: SafeArea(
            child: ListenableProvider.value(
          value: Provider.of<UserModel>(context, listen: false),
          child: Consumer<UserModel>(builder: (context, value, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 70.0,
                    ),
                    Container(
                      child: Center(
                          child: Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.contain,
                      )),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      onChanged: (value) => firstName = value,
                      decoration: const InputDecoration(
                        labelText: 'First Name ',
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      onChanged: (value) => lastName = value,
                      decoration: const InputDecoration(
                        labelText: 'Last Name ',
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      controller: _usernameController,
                      onChanged: (value) => username = value,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Enter your email'),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => password = value,
                      decoration: const InputDecoration(
                        labelText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: isChecked,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (value) {
                            //print(value);
                            isChecked = !isChecked;
                            setState(() {});
                          },
                        ),
                        const Text('I want to create an account',
                            style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        elevation: 0,
                        child: MaterialButton(
                          onPressed: () async {
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: username, password: password);
                            } catch (e) {
//                              print(e);
                            }
                            _submitRegister(
                                firstName, lastName, username, password);
                          },
                          minWidth: 200.0,
                          elevation: 0.0,
                          height: 42.0,
                          child: Text(
                            value.loading == true
                                ? 'LOADING...'
                                : 'CREATE AN ACCOUNT',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'or ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'login to your account',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        )));
  }
}
