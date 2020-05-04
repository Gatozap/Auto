import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Marketplace/GoogleMaps/GoogleMapsPage.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:meta/meta.dart';

import 'diagonally_cut_colored_image.dart';

class FriendDetailHeader extends StatefulWidget {
  static const BACKGROUND_IMAGE = 'assets/splash.png';
  User user;
  FriendDetailHeader({this.user});

  @override
  _FriendDetailHeaderState createState() => _FriendDetailHeaderState();
}

class _FriendDetailHeaderState extends State<FriendDetailHeader> {
  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        FriendDetailHeader.BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xFF40C4FF),
    );
  }

  Widget _buildAvatar() {
    String initials = '';
    var words = widget.user.nome.split(' ');
    for (String word in words) {
      initials += word.split('')[0].toUpperCase();
    }
    return widget.user.foto != null
        ? CircleAvatar(
            radius: ScreenUtil.getInstance()
                .setSp(150),
            backgroundColor: Colors.purple,
            backgroundImage: CachedNetworkImageProvider(widget.user.foto))
        : CircleAvatar(
            radius: ScreenUtil.getInstance()
                .setSp(150),
            backgroundColor: Colors.purple,
            child: hText(initials, context, size:150,color: Colors.white));
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Telefone: ${widget.user.celular}',

            style: followerStyle,
          ),

        ],
      ),

    );
  }

  Widget _buildPrestadorInfo(TextTheme textTheme) {
    var followerStyle =
    textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[


          IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GoogleMapsPage(user: widget.user,)));
          }, icon: Icon(Icons.place), iconSize: 50, color: Colors.red,)
        ],
      ),

    );
  }

  Widget _buildActionButtons(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Email: ${widget.user.email}', style: followerStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(textTheme),
              _buildPrestadorInfo(textTheme),
            ],
          ),
        ),
        new Positioned(
          top: 40.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}
