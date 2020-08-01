import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Helpers.dart';

import 'package:autooh/Objetos/Message.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';

import 'package:image_picker/image_picker.dart';

import 'ChatController.dart';

class ChatPage extends StatefulWidget {
  User user;
  Sala sala;

  bool isFromHome;
  ChatPage({this.user, this.sala, this.isFromHome = false});

  @override
  _ChatPageState createState() {
    return _ChatPageState();
  }
}

@override
class ChatMessageIndividual extends StatelessWidget {
  ChatMessageIndividual({this.snapshot, this.animation});

  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    String r = new Random().nextInt(1000000000).toString();
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new GestureDetector(
              onTap: () {},
              child: new Hero(
                  tag: r,
                  child: new Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.00, right: 10.0, top: 3.0, left: 5.0),
                      child: new Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new CachedNetworkImageProvider(
                                      snapshot.value['senderFoto'])))))),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(snapshot.value['senderName'],
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: snapshot.value['imgUrl'] != null
                        ? new Image.network(
                            snapshot.value['imgUrl'],
                            width: 250.0,
                          )
                        : new Text(snapshot.value['msg']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = new TextEditingController();
  ChatController cc;

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    if (cc == null) {
      if (widget.sala != null) {
        cc = new ChatController(widget.sala);
      } else {
        cc = new ChatController(null, isFromHome: widget.isFromHome);
      }
    }
    int NonReads = 0;
    String avatarPic;
    var partnerName = '';
    if (!widget.isFromHome) {
      if (widget.sala.meta['suporte'] != null) {
        // print('AQUI META  >>>> ${i[Helper.localUser.id]}');
        partnerName = widget.sala.meta['suporte']['partnerName'];
        avatarPic = widget.sala.meta['suporte']['foto'];
        NonReads = widget.sala.meta['suporte']['NonRead'];
      }
      double radius = ((MediaQuery.of(context).size.width * .05) +
              (MediaQuery.of(context).size.height * .05)) /
          2;
      String otherUserId;
      for (var i in widget.sala.membros) {
        if (i != 'suporte') {
          otherUserId = i;
          partnerName = widget.sala.meta[otherUserId]['partnerName'];
          avatarPic = widget.sala.meta[otherUserId]['foto'];
          NonReads = widget.sala.meta[otherUserId]['NonRead'];
        }
      }
    }
    return Scaffold(
        appBar: myAppBar(
          '${!widget.isFromHome ? partnerName : 'Suporte Autooh'}',
          context,
          showBack: true,
        ),
        body: StreamBuilder<Sala>(
            stream: cc.outSala,
            builder: (context, sala) {
              if (sala.data != null) {
                return Stack(
                  children: <Widget>[
                    StreamBuilder<bool>(
                        stream: cc.outHide,
                        builder: (context, hide) {
                          if (hide.data == null) {
                            return Container();
                          }
                          return new Column(children: <Widget>[
                            new Flexible(
                              child: cc.reference != null
                                  ? new FirebaseAnimatedList(
                                      query: cc.reference
                                          .orderByChild('timestamp')
                                          .limitToLast(30),
                                      sort: (DataSnapshot a, DataSnapshot b) =>
                                          b.key.compareTo(a.key),
                                      padding: new EdgeInsets.all(8.0),
                                      reverse: true,
                                      itemBuilder: (BuildContext context,
                                          DataSnapshot snapshot,
                                          Animation<double> animation,
                                          _) {
                                        //  print('AQUI SNAP' + snapshot.toString());
                                        return MessageBubble(cc, widget.user,
                                            snapshot: snapshot,
                                            animation: animation);
                                      },
                                    )
                                  : Container(),
                            ),
                            new Divider(height: 1.0),
                            new Container(
                              decoration: new BoxDecoration(
                                  color: Theme.of(context).cardColor),
                              child: _buildTextComposer(),
                            ),
                          ]);
                        }),
                  ],
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () async {
                    File imageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    int random = new Random().nextInt(100000);
                    StorageReference ref = FirebaseStorage.instance
                        .ref()
                        .child("image_$random.jpg");
                    StorageUploadTask uploadTask = ref.putFile(imageFile);
                    uploadTask.onComplete.then((d) {
                      d.ref.getDownloadURL().then((url) {
                        var downloadUrl = url;
                        cc.sendMessage(imageUrl: downloadUrl.toString());
                      });
                    });
                  }),
            ),
            new Flexible(
              child: new TextField(
                autocorrect: true,
                autofocus: false,
                enableInteractiveSelection: true,
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Diga Algo"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    print("user ${widget.user}");
    cc.sendMessage(text: text, user: widget.user);
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.cc, this.user, {this.snapshot, this.animation});
  ChatController cc;
  User user;
  final DataSnapshot snapshot;
  final Animation animation;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      user = User();
    }
    bool isMe = user.nome == snapshot.value['senderName'];
    Message m = Message.fromJson(snapshot.value);
    String initials = '';
    var words = snapshot.value['senderName'].split(' ');
    for (int i = 0; i < words.length; i++) {
      if (i < 2) {
        initials += words[i].split('')[0].toUpperCase();
      }
    }
    return isMe
        ? new SizeTransition(
            sizeFactor:
                new CurvedAnimation(parent: animation, curve: Curves.easeOut),
            axisAlignment: 0.0,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                    padding: EdgeInsets.only(
                        bottom: 10.00, right: 10.0, top: 20.0, left: 5.0),
                    child: snapshot.value['senderFoto'] == ''
                        ? CircleAvatar(
                            radius: ScreenUtil.getInstance().setSp(60),
                            backgroundColor: Colors.purple,
                            child: hText(initials, context,
                                size: 30, color: Colors.white))
                        : new Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new CachedNetworkImageProvider(
                                        snapshot.value['senderFoto']))))),
                sb,
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      hText(snapshot.value['senderName'], context,
                          color: Colors.black54, size: 45),
                      sb,
                      Material(
                        borderRadius: isMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0))
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                        elevation: 5.0,
                        color: isMe ? vermelho : Colors.green,
                        child: Row(
                          children: <Widget>[
                            LimitedBox(
                              maxWidth: getLargura(context) * .7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: snapshot.value['imgUrl'] != null
                                    ? new Image.network(
                                        snapshot.value['imgUrl'],
                                        width: 250.0,
                                      )
                                    : hText(snapshot.value['msg'], context,
                                        color: Colors.white,
                                        size: 45,
                                        textaling: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                      ),
                      sb,
                      hText(
                          Helpers().readTimestamp(
                              DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.value['timestamp'])),
                          context,
                          size: 35,
                          color: Colors.black54),
                    ],
                  ),
                ),
              ],
            ))
        : new SizeTransition(
            sizeFactor:
                new CurvedAnimation(parent: animation, curve: Curves.easeOut),
            axisAlignment: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  sb,
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        hText(snapshot.value['senderName'], context,
                            color: Colors.black54, size: 45),
                        Material(
                          borderRadius: isMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))
                              : BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                          elevation: 5.0,
                          color: isMe ? vermelho : Colors.green,
                          child: Row(
                            children: <Widget>[
                              LimitedBox(
                                maxWidth: getLargura(context) * .7,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: snapshot.value['imgUrl'] != null
                                      ? new Image.network(
                                          snapshot.value['imgUrl'],
                                          width: 250.0,
                                        )
                                      : hText(snapshot.value['msg'], context,
                                          color: Colors.white,
                                          size: 45,
                                          textaling: TextAlign.end),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sb,
                        hText(
                            Helpers().readTimestamp(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.value['timestamp'])),
                            context,
                            size: 35,
                            color: Colors.black54),
                      ],
                    ),
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.00, right: 10.0, top: 20.0, left: 5.0),
                      child: CircleAvatar(
                          radius: ScreenUtil.getInstance().setSp(60),
                          backgroundColor: Colors.purple,
                          backgroundImage: AssetImage('assets/autooh.png'))),
                ],
              ),
            ));
  }
}
