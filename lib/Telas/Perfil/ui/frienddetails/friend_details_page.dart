import 'package:bocaboca/Objetos/User.dart';

import 'package:flutter/material.dart';



import 'footer/friend_detail_footer.dart';
import 'friend_detail_body.dart';
import 'header/friend_detail_header.dart';

class FriendDetailsPage extends StatefulWidget {
  User user;
  FriendDetailsPage(
      { this.user

  });



  @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF0288D1),
          const Color(0xFF01579B),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(
                  user: widget.user,

              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
