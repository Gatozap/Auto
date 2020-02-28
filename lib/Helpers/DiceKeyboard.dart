import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Message.dart';
import 'package:autooh/Objetos/Notificacao.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'References.dart';

/// A quick example "keyboard" widget for picking a color.
class DiceKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<int>
    implements PreferredSizeWidget {
  final ValueNotifier<int> notifier;
  static const double _kKeyboardHeight = 200;
  Sala sala;
  User user;
  int messageDelay = 3;

  DiceKeyboard({Key key, this.notifier, this.sala, this. user}) : super(key: key);

  void sendMessage({String text, String imageUrl}) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('Chats')
        .child('${sala.sala}');
    Message msg;
    if (imageUrl != null) {
      msg = Message(
          msg: text,
          imgUrl: imageUrl,
          senderName: Helper.localUser.nome,
          senderFoto:
          Helper.localUser.foto == null ? '' : Helper.localUser.foto,
          senderId: Helper.localUser.id,
          timestamp: DateTime.now());
    } else {
      msg = Message(
          msg: text,
          imgUrl: null,
          senderName: Helper.localUser.nome,
          senderFoto:
          Helper.localUser.foto == null ? '' : Helper.localUser.foto,
          senderId: Helper.localUser.id,
          timestamp: DateTime.now());
    }
    reference.push().set(msg.toJson());
    sala.lastMessage = msg;
    sala.updated_at = DateTime.now();
    if (user != null) {
      if (sala.meta[user.id] != null) {
        sala.meta[user.id]['NonRead'] = sala.meta[user.id]['NonRead'] + 1;
      }
    }
    chatRef.document(sala.id).updateData(sala.toJson()).then((v) {
    });

    //TODO ARRUMAR SEND NOTIFICATION
    sendNotificationUsuario(text, imageUrl);

    Helper.analytics.logEvent(name: 'send_message');
  }
  @override
  Widget build(BuildContext context) {
    final double rows = 2;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int colorsCount = 8;
    final int colorsPerRow = (colorsCount / rows).ceil();
    final double itemWidth = screenWidth / colorsPerRow;
    final double itemHeight = _kKeyboardHeight / rows;

    return Container(
      height: _kKeyboardHeight,
      child: Wrap(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(1) + 1;
              updateValue(value);
                sendMessage(text:'Rolou 1d2 com Resultado ${value}',);
            },onLongPress: (){
              dToast('Rolar Dado de 2 façes');
          },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d2.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(3) + 1;
              updateValue(value);
                sendMessage(text:'Rolou 1d4 com Resultado ${value}',);
            },
    onLongPress: (){
    dToast('Rolar Dado de 4 façes');
    },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d4.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(5) + 1;
              updateValue(value);
              Future.delayed(Duration(seconds: messageDelay)).then((v){
                sendMessage(text:'Rolou 1d6 com Resultado ${value}',);
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(contentPadding: EdgeInsets.all(0), shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      content:  Container(width:getLargura(context)*.3,height: getAltura(context)*.3,child: new FlareActor("assets/ResultDie.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"DieRoll${value}")),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK",style: TextStyle(color: corPrimaria),),
                          onPressed: () => Navigator.of(context).pop(),
                          )
                      ],
                      );

                  });
            },
            onLongPress: (){
              dToast('Rolar Dado de 6 façes');
            },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d6.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(7) + 1;
              updateValue(value);
                sendMessage(text:'Rolou 1d8 com Resultado ${value}',);
            },
            onLongPress: (){
              dToast('Rolar Dado de 8 façes');
            },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d8.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(10) + 1;
              updateValue(value);
              Future.delayed(Duration(seconds: messageDelay)).then((v){
                sendMessage(text:'Rolou 1d10 com Resultado ${value}',);
              });
            },
            onLongPress: (){
              dToast('Rolar Dado de 10 façes');
            },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d10.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(11) + 1;
              updateValue(value);
                sendMessage(text:'Rolou 1d12 com Resultado ${value}',);
            },   onLongPress: (){
            dToast('Rolar Dado de 12 façes');
          },

            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d12.png'),
              ),

              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onLongPress: (){
              dToast('Rolar Dado de 20 façes');
            },
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(19) + 1;
              updateValue(value);
              Future.delayed(Duration(seconds: messageDelay)).then((v){
                sendMessage(text:'Rolou 1d20 com Resultado ${value}',);
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(contentPadding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      content:  Container(width:getLargura(context)*.3,height: getAltura(context)*.3,child: new FlareActor("assets/dice20.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"Spin${value}")),
                        actions: <Widget>[
                        FlatButton(
                          child: Text("OK",style: TextStyle(color: corPrimaria),),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );

                  });
            },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d20_button.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
          GestureDetector(
            onTap: () {
              Random r = new Random();
              int value = r.nextInt(99) + 1;
              updateValue(value);
                sendMessage(text:'Rolou 1d100 com Resultado ${value}',);
            },
            onLongPress: (){
              dToast('Rolar Dado de 100 façes');
            },
            child: Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/d100.png'),
              ),
              width: itemWidth,
              height: itemHeight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_kKeyboardHeight);

  sendNotificationUsuario(text, imageUrl) async {
    print('INICIANDO NOTIFICAÇÃO');
    /* 'title': '${Helpers.user.nome} Apoiou o protocolo ${post.titulo}',
      'responsavel': json.encode(Helpers.user),
      'tipo': 0.toString(),
      'sujeito': post.id.toString(),
      'topic': 'protocoloteste' + post.id.toString(),
      'foto': Helpers.user.foto == null
          ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
          : Helpers.user.foto,
      'data': DateTime.now().millisecondsSinceEpoch.toString(),*/
    Notificacao n = new Notificacao(
        title: '${text}',
        message: '${Helper.localUser.nome} enviou uma mensagem',
        behaivior: 0,
        sended_at: DateTime.now(),
        sender: Helper.localUser.id,
        topic: user != null ? user.id : sala.id,
        data: json.encode({
                            'sala': sala.id,
                            'user': Helper.localUser.toJson(),
                            'title': '${text}',
                            'message': '${Helper.localUser.nome} enviou uma mensagem',
                            'behaivior': 0,
                            'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
                            'sender': Helper.localUser.id,
                            'topic': user != null ? user.id : sala.id,
                          }));
    n.image = imageUrl == null ? null : imageUrl;

    http.post(notificationUrl, body: n.toJson()).then((v) {
      //print(v.body);
      print('ENVIOU NOTIFICAÇÂO ${n.toString()}');
      notificacoesRef.add(n.toJson());
    }).catchError((e) {
      print('Err:' + e.toString());
    });
    /*n.topic = Helper.localUser.id;
    n.image = imageUrl == null ? null : imageUrl;
    http.post(url, body: n.toJson()).then((v) {
      print('PASSOU CARALEO');
      print(v.body);
      notificacoesRef.add(n.toJson());
    }).catchError((e) {
      print('Err:' + e.toString());
    });*/
  }
}
