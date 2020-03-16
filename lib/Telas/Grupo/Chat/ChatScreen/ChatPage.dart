import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Grupo/Chat/Membros/MembrosPage.dart';

import '../TabuleiroController.dart';
import 'ChatController.dart';

class ChatPage extends StatefulWidget {
  User user;
  Sala sala;

  ChatPage({this.user, this.sala});

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
        cc = new ChatController(null, true, null, widget.sala.id);
        Helper.fbmsg.subscribeToTopic(widget.sala.id);
      } else {
        cc = new ChatController(widget.user, true, null, null);
      }
    }
    return Scaffold(
        drawer: CustomDrawerWidget(),
        appBar: myAppBar(
            '${widget.user != null ? widget.user.nome : widget.sala.name}',
            context,
            showBack: true,
            actions: [
              widget.user != null
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MembrosPage(widget.sala)));
                      },
                    ),
              StreamBuilder<Object>(
                  stream: cc.outHide,
                  builder: (context, hide) {
                    if (hide.data) {
                      return Container(
                        width: getLargura(context) * .15,
                        child: MaterialButton(color: corPrimaria,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Icon(
                                    Icons.chat,
                                    color: Colors.white,size:25
                                  ),
                                ),
                              Center(
                                child: Icon(
                                  Icons.block,
                                  color: Colors.grey,
                                    size:30
                                  ),
                              )
                              ],
                            ),
                            onPressed: () {
                              cc.inHide.add(false);
                            }),
                      );
                    }
                    return Container(
                        width: getLargura(context) * .15,
                        child: MaterialButton(color: corPrimaria,
                          child: Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            cc.inHide.add(true);
                          },
                        ));
                  })
            ]),
        body: StreamBuilder<Sala>(
            stream: cc.outSala,
            builder: (context, sala) {
              if (sala.data != null) {
                return Stack(
                  children: <Widget>[
                    StreamBuilder<bool>(
                        stream: cc.outHide,
                        builder: (context, hide) {
                          if (hide.data ==null) {
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
                                        return MessageBubble(
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
                return LoadingScreen('Abrindo Sala');
              }
            }));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: corPrimaria),
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
    cc.sendMessage(text: text);
  }

}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    bool isMe = Helper.localUser.nome == snapshot.value['senderName'];
    return isMe
        ? new SizeTransition(
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
                          color: isMe ? corPrimaria : corSecundaria,
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
                                          size: 44,
                                          textaling: TextAlign.end),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sb,
                        hText(
                            Helper().readTimestamp(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.value['timestamp'])),
                            context,
                            color: Colors.black54),
                      ],
                    ),
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.00, right: 10.0, top: 3.0, left: 5.0),
                      child: new Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: snapshot.value['senderFoto'] == ''
                                      ? AssetImage(
                                          'assets/no_pic_character.png')
                                      : new CachedNetworkImageProvider(
                                          snapshot.value['senderFoto']))))),
                ],
              ),
            ))
        : new SizeTransition(
            sizeFactor:
                new CurvedAnimation(parent: animation, curve: Curves.easeOut),
            axisAlignment: 0.0,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                    padding: EdgeInsets.only(
                        bottom: 10.00, right: 10.0, top: 3.0, left: 5.0),
                    child: new Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: snapshot.value['senderFoto'] == ''
                                    ? AssetImage('assets/no_pic_character.png')
                                    : new CachedNetworkImageProvider(
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
                          color: Colors.black54),
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
                        color: isMe ? corPrimaria : corSecundaria,
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
                                        size: 44,
                                        textaling: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                      ),
                      sb,
                      hText(
                          Helper().readTimestamp(
                              DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.value['timestamp'])),
                          context,
                          color: Colors.black54),
                    ],
                  ),
                ),
              ],
            ));
  }
}
