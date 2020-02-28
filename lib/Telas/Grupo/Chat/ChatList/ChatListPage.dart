import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/BadgerController.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Sala.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:bocaboca/Telas/Grupo/Chat/ChatScreen/ChatPage.dart';
import 'package:bocaboca/Telas/Grupo/Chat/CriarGrupo/CriarGrupoPage.dart';
import 'package:bocaboca/Telas/Grupo/Chat/ListGrupoPage/list_grupo_page.dart';

import 'ChatListController.dart';

class ChatListPage extends StatefulWidget {
  bool ShowBack;
  ChatListPage({this.ShowBack = false});

  @override
  _ChatListPageState createState() {
    return _ChatListPageState();
  }
}

class _ChatListPageState extends State<ChatListPage> {
  ChatListController clc;
  @override
  Widget build(BuildContext context) {
    bc.removeBadges(
      0,
    );
    if (clc == null) {
      clc = new ChatListController();
    }
    // TODO: implement build
    return Scaffold(
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('Conversas', context,
          /*actions: [
            IconButton(
                    icon: Icon(Icons.create),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CriarGrupoPage()));
                    },
                  ),
          IconButton(
                    icon: Icon(Icons.group),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListGrupoPage()));
                    },
                  ),
          ],*/
          showBack: widget.ShowBack),
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
                                    SalaListItem(salas.data[index], context))));
                  },
                );
              } else {
                return Center(child:hText('Nenhuma conversa no momento',context));
              }
            } else {
              return LoadingScreen('Carregando Salas');
            }
          }),
    );
  }
}

Widget SalaListItem(Sala s, context) {
  if (s.isPrivate) {
    int NonReads = 0;
    String avatarPic;
    var partnerName = '';
    if (s.meta[Helper.localUser.id] != null) {
      // print('AQUI META  >>>> ${i[Helper.localUser.id]}');
      partnerName = s.meta[Helper.localUser.id]['partnerName'];
      avatarPic = s.meta[Helper.localUser.id]['foto'];
      NonReads = s.meta[Helper.localUser.id]['NonRead'];
    }
    double radius = ((MediaQuery.of(context).size.width * .03) +
            (MediaQuery.of(context).size.height * .03)) /
        2;
    String otherUserId;
    for (var i in s.membros) {
      if (i != Helper.localUser.id) {
        otherUserId = i;
      }
    }
    return MaterialButton(
      onPressed: () {
        print('AQUI ID ${otherUserId}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    user: User(
                        id: otherUserId, nome: partnerName, foto: avatarPic))));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(avatarPic),
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
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      SizedBox(
                        height: 3,
                      ),
                      s.lastMessage != null
                          ? LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height * .3,
                              maxWidth:
                                  MediaQuery.of(context).size.width * .5,
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
    );
  } else {
    int NonReads = 0;
    String avatarPic;
    var partnerName = '';
    if (s.meta[Helper.localUser.id] != null) {
      // print('AQUI META  >>>> ${i[Helper.localUser.id]}');
      partnerName = s.meta[Helper.localUser.id]['partnerName'];

      NonReads = s.meta[Helper.localUser.id]['NonRead'];
    }

    if(s.foto != null){
      avatarPic = s.foto;
    }
    double radius = ((MediaQuery.of(context).size.width * .03) +
            (MediaQuery.of(context).size.height * .03)) /
        2;
    String otherUserId;
    for (var i in s.membros) {
      if (i != Helper.localUser.id) {
        otherUserId = i;
      }
    }
    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      sala: s,
                    )));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: avatarPic == null?                AssetImage('https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'): CachedNetworkImageProvider(avatarPic),
                      radius: radius,backgroundColor: Colors.white,
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
                              s.name,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      SizedBox(
                        height: 3,
                      ),
                      LimitedBox(
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
                      ),
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
    );
  }
}
