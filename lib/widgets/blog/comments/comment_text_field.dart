import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/user.dart';
import '../../../screens/login.dart';
import '../../../services/wordpress.dart';

class CommentInput extends StatefulWidget {
  final int blogId;

  CommentInput({this.blogId});
  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final comment = TextEditingController();

  void sendComment() async {
    final user = Provider.of<UserModel>(context, listen: false);
    print('user ${user.user}');
    print(widget.blogId);

    bool commentCreated = await WordPress().createComment(
      blogId: widget.blogId,
      content: comment.text,
      authorName: (user.user.name != null) ? user.user.name : "Guest",
      authorAvatar: user.user.picture != null
          ? user.user.picture
          : 'https://api.adorable.io/avatars/60/${user.user.name != null ? user.user.name : 'guest'}.png',
      userEmail: user.user.email != null ? user.user.email : null,
      date: DateTime.now().toIso8601String(),
    );
    setState(() {
      comment.text = "";
    });
    if (commentCreated) {
      final snackBar =
          SnackBar(content: Text(S.of(context).commentSuccessfully));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    } else {
      const snackBar = SnackBar(content: Text("Comment fail"));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
//        .then((onValue) {
//      setState(() {
//        comment.text = "";
//      });
//      final snackBar =
//          SnackBar(content: Text(S.of(context).commentSuccessfully));
//      Scaffold.of(context).showSnackBar(snackBar);
//      return;
//    });
  }

  bool _isLoggedInUser() {
    final user = Provider.of<UserModel>(context, listen: false);
    if (user.user != null) {
      return true;
    } else {
      return true;
    }
  }

  // Widget _buildCommentSection() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: <Widget>[
  //       Expanded(
  //         child: TextField(
  //           controller: comment,
  //           maxLines: 2,
  //           decoration:
  //               InputDecoration(hintText: "${S.of(context).writeComment}"),
  //         ),
  //       ),
  //       GestureDetector(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Icon(
  //             Icons.send,
  //             color: Theme.of(context).accentColor,
  //           ),
  //         ),
  //         onTap: sendComment,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildRequiredLoginButton() {
  //   return Container(
  //     constraints: const BoxConstraints(
  //       minHeight: 32,
  //       maxHeight: 64,
  //       minWidth: 200,
  //       maxWidth: 320,
  //     ),
  //     height: 50.0,
  //     child: RawMaterialButton(
  //       onPressed: () => Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => LoginScreen(),
  //         ),
  //       ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             "${S.of(context).loginToComment}",
  //             style: TextStyle(
  //               color: Theme.of(context).primaryColorLight,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           )
  //         ],
  //         mainAxisAlignment: MainAxisAlignment.center,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       elevation: 0.4,
  //       fillColor: Theme.of(context).buttonTheme.colorScheme.primary,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 40, top: 15.0),
    //   padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 5.0),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).backgroundColor,
    //     borderRadius: BorderRadius.circular(3.0),
    //   ),
    //   child: _isLoggedInUser()
    //       ? _buildCommentSection()
    //       : _buildRequiredLoginButton(),
    // );
  }
}
