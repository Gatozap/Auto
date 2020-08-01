import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Helpers.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Chat/ChatScreen/ChatPage.dart';
import 'ChatListController.dart';

class ChatListPage extends StatefulWidget {
  bool ShowBack;
  ChatListPage( {this.ShowBack = false});

  @override
  _ChatListPageState createState() {
    return _ChatListPageState();
  }
}

class _ChatListPageState extends State<ChatListPage> {
  ChatListController clc;
  @override
  Widget build(BuildContext context) {

    if (clc == null) {
      clc = new ChatListController();
    }
    return Scaffold( appBar: myAppBar("Chat com clientes", context),
      body: StreamBuilder(
          stream: clc.outSalas,
          builder: (context, AsyncSnapshot<List<Sala>> salas) {
            if (salas.data != null) {
              if (salas.data.length != 0) {
                return ListView.builder(
                  itemCount: salas.data.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child:
                                    SalaListItem(salas.data[index], context,null))));
                  },
                );
              } else {
                return Center(
                    child: hText('Nenhuma conversa no momento', context));
              }
            } else {
              return LoadingScreen('Carregando Salas');
            }
          }),
    );
  }
}

Widget SalaListItem(Sala s, context, User user) {
  int NonReads = 0;
  String avatarPic;
  var partnerName = '';
  if (s.meta['suporte'] != null) {
    // print('AQUI META  >>>> ${i[Helper.localUser.id]}');
    partnerName = s.meta['suporte']['partnerName'];
    avatarPic = s.meta['suporte']['foto'];
    NonReads = s.meta['suporte']['NonRead'];
  }
  double radius = ((MediaQuery.of(context).size.width * .05) +
      (MediaQuery.of(context).size.height * .05)) /
      2;
  String otherUserId;
  for (var i in s.membros) {
    if (i != 'suporte') {
      otherUserId = i;
      partnerName = s.meta[otherUserId]['partnerName'];
      avatarPic =s.meta[otherUserId]['foto'];
      NonReads = s.meta[otherUserId]['NonRead'];
    }
  }
  return MaterialButton(
    onPressed: () {
      print('AQUI ID ${otherUserId}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatPage(sala: s,user: user,)));
    },
    child: Card(
      elevation: 10,
      shadowColor: vermelho,
      
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  avatarPic == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(avatarPic),
                            radius: radius,
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      s.lastMessage != null
                          ? Text(
                              partnerName,
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            )
                          : Container(),
                      SizedBox(
                        height: 3,
                      ),
                      s.lastMessage != null
                          ? LimitedBox(
                              maxHeight: MediaQuery.of(context).size.height * .3,
                              maxWidth: MediaQuery.of(context).size.width * .5,
                              child: s.lastMessage != null
                                  ? NonReads != 0
                                      ? Text(
                                          s.lastMessage.msg == null
                                              ? 'Enviou uma Foto'
                                              : s.lastMessage.msg,
                                          softWrap: true,
                                        )
                                      : Text(
                                          s.lastMessage.msg == null
                                              ? 'Enviou uma Foto'
                                              : s.lastMessage.msg,
                                          softWrap: true)
                                  : Container(),
                            )
                          : Container(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          s.lastMessage != null
                              ? Text(
                                  s.updated_at.day != DateTime.now().day
                                      ? '${s.updated_at.day}/${s.updated_at.month} - ${s.updated_at.hour}:${s.updated_at.minute}'
                                      : '${s.updated_at.hour}:${s.updated_at.minute}',
                                  style: TextStyle(color: Colors.black),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
