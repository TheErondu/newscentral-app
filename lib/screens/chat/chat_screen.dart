import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../common/config.dart' as config;
import '../../common/styles.dart';
import '../../models/user.dart';
import 'chat_typing.dart';
import 'messages.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  final User user;
  final String adminEmail = config.adminEmail;
  final String userEmail;
  final bool isAdmin;

  ChatScreen({this.user, this.userEmail, this.isAdmin = false});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  var uuid = Uuid();
  String messagesText = '';
  File imageFile;
  String imageUrl;

  @override
  void initState() {
//    getCurrentUser();

    Future.delayed(Duration.zero, getCurrentUser);

    super.initState();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null && mounted) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (e) {
//      print(e.toString());
    }
  }

  updateTyping(bool status) {
    String user = widget.isAdmin ? widget.userEmail : loggedInUser.email;
    var document = _fireStore.collection('chatRooms').document(user);

    if (loggedInUser.email == widget.adminEmail) {
      document.updateData({'adminTyping': status});
    } else {
      document.updateData({'userTyping': status});
    }
  }

  @override
  Widget build(BuildContext context) {
//    if (loggedInUser == null) {
//      Provider.of<UserModel>(context).logout();
//      Navigator.of(context).pushNamed('/login');
//      return Container(
//        color: Theme.of(context).backgroundColor,
//        child: kLoadingWidget(context),
//      );
//    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushNamed(context, '/home');
            }
          },
        ),
        title: widget.isAdmin
            ? Text(
                '${widget.userEmail}',
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Contact with supporter',
                style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(
                isAdmin: widget.isAdmin,
                userEmail:
                    widget.isAdmin ? widget.userEmail : loggedInUser.email,
                user: loggedInUser,
              ),
              TypingStream(
                isAdminLoggedIn: loggedInUser.email == widget.adminEmail,
                userEmail:
                    widget.isAdmin ? widget.userEmail : loggedInUser.email,
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messagesText = value;
                          updateTyping(true);
                        },
                        onEditingComplete: () {
                          updateTyping(false);
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageTextController.clear();
                        if (messagesText.isNotEmpty) {
                          //deal with database if admin is true
                          if (widget.isAdmin) {
                            _fireStore
                                .collection('chatRooms')
                                .document(widget.userEmail)
                                .collection('chatScreen')
                                .add({
                              'text': messagesText,
                              'sender': widget.adminEmail,
                              'createdAt': DateTime.now().toString(),
                            });

                            _fireStore
                                .collection('chatRooms')
                                .document(widget.userEmail)
                                .setData({
                              'adminTyping': false,
                              'lastestMessage': messagesText,
                              'userEmail': widget.userEmail,
                              'createdAt': DateTime.now().toIso8601String(),
                              'isSeenByAdmin': true,
                              'userTyping': false,
                              'image': ''
                            }, merge: true);
                          } else {
                            //else treat as normal user
                            _fireStore
                                .collection('chatRooms')
                                .document(loggedInUser.email)
                                .collection('chatScreen')
                                .add({
                              'text': messagesText,
                              'sender': loggedInUser.email,
                              'createdAt': DateTime.now().toString(),
                            });
                            _fireStore
                                .collection('chatRooms')
                                .document(loggedInUser.email)
                                .setData({
                              'lastestMessage': messagesText,
                              'userTyping': false,
                              'userEmail': loggedInUser.email,
                              'createdAt': DateTime.now().toIso8601String(),
                              'isSeenByAdmin': false,
                              'adminTyping': false,
                              'image': ''
                            }, merge: true);
                          }
                        }
                        messagesText = '';
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
