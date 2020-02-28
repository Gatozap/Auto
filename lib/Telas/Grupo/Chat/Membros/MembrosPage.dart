import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Notificacao.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Grupo/Chat/ChatScreen/ChatPage.dart';

import '../../../../main.dart';
import 'MembrosController.dart';

class MembrosPage extends StatefulWidget {
  Sala s;

  MembrosPage(this.s);

  @override
  _MembrosPageState createState() {
    return _MembrosPageState();
  }
}

class _MembrosPageState extends State<MembrosPage> {
  TextEditingController controllerConvidar = TextEditingController();
  MembrosController mc;
  bool isAdm = false;
  @override
  Widget build(BuildContext context) {
    if (mc == null) {
      mc = new MembrosController(widget.s);
    }

    isAdm = widget.s.meta[Helper.localUser.id]['isAdm'];
    return Scaffold(
      appBar: myAppBar(
        widget.s.name,
        context,
        showBack: true,
      ),
      body: Column(
        children: <Widget>[
       Padding(
                  padding: ei,
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: controllerConvidar,
                        keyboardType: TextInputType.text,
                        decoration: DefaultInputDecoration(context,
                          icon: Icons.person,
                          hintText: 'João da Silva',
                          labelText: 'Convidar para o Grupo',
                        ),
                        textCapitalization: TextCapitalization.words,
                        enabled: true),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestions(pattern);
                    },
                    itemBuilder: (context, User suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: suggestion.foto != null
                                ? CachedNetworkImageProvider(suggestion.foto)
                                : AssetImage('assets/images/customer.jpg'),
                            minRadius: 25,
                            maxRadius: 25,
                          ),
                          title: Text(suggestion.nome),
                        ),
                      );
                    },
                    onSuggestionSelected: ConvidarUsuario,
                    noItemsFoundBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Nenhum item Encontrado'),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  ConvidarUsuario(User suggestion,{bool isAproving = false}) {
    dToast(isAproving? '${suggestion.nome} Adicionado':'Convite Enviado');
    List membros = new List();
    for (var i in widget.s.membros) {
      membros.add(i);
    }
    if (!membros.contains(suggestion.id)) {
      membros.add(suggestion.id);
    }
    widget.s.membros = membros;
    var m = {
      'foto': suggestion.foto != null
          ? suggestion.foto
          : 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7',
      'NonRead': 0,
      'partnerName': suggestion.nome,
      'isAdm': false,
    };
    widget.s.meta[suggestion.id] = m;
    print('CHEGOU AQUI DEMONIO');
    chatRef.document(widget.s.id).updateData(widget.s.toJson()).then((v) {
      print('Atualizado Com Sucesso!');
      mc = new MembrosController(widget.s);
      sendNotificationUsuario(
          widget.s.name,
          isAproving? 'Você foi aceito no grupo ${widget.s.name}':'${Helper.localUser.nome} Convidou você para fazer parte de um grupo',
          widget.s.foto != null ? widget.s.foto : null,
          suggestion.id);
    }).catchError((err) {
      print('Erro ao Convidar:${err.toString()}');
    });
  }

  sendNotificationUsuario(text, String subtext, imageUrl, String id) async {
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
        message: subtext,
        behaivior: 0,
        sended_at: DateTime.now(),
        sender: Helper.localUser.id,
        topic: id,
        data: json.encode({
          'sala': widget.s.id,
          'user': Helper.localUser.toJson(),
          'title': '${text}',
          'message':
              '${Helper.localUser.nome} Convidou você para fazer parte de um grupo',
          'behaivior': 0,
          'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': Helper.localUser.id,
          'topic': id,
        }));
    n.image = imageUrl == null ? null : imageUrl;

    http.post(notificationUrl, body: n.toJson()).then((v) {
      //print(v.body);
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

  Future<List<User>> getSuggestions(String pattern) {
    return userRef
        .where('nome', isGreaterThanOrEqualTo: pattern)
        .where('nome', isLessThan: pattern + 'z')
        .getDocuments()
        .then((v) {
      List<User> users = new List();
      for (var i in v.documents) {
        User u = new User.fromJson(i.data);
        if (!users.contains(u)) {
          if (u.id != Helper.localUser.id) {
            bool contains = false;
            if (users != null) {
              for (User s in users) {
                if (s.id == u.id) {
                  contains = true;
                }
              }
            }
            if (!contains) {
              users.add(u);
            }
          }
        }
      }
      return users;
    });
  }

  Widget ParticipanteListItem(User user) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  user.foto != null
                  ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.foto),
                    minRadius: 12,
                    maxRadius: 25,
                    )
                  : CircleAvatar(
                    minRadius: 12,
                    maxRadius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(
                      user.genero == 'Masculino'
                      ? MdiIcons.humanMale
                      : MdiIcons.humanFemale,
                      color: user.genero == 'Masculino'
                             ? Colors.blueAccent
                             : Colors.pink,
                      size: 25,
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.nome.length > 15
                        ? user.nome.substring(0, 15) + '...'
                        : user.nome,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .045,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                        ),
                      user.isGroupAdm
                      ? Text(
                        'Administrador',
                        style: TextStyle(color: corPrimaria, fontSize: 10),
                        )
                      : Container(),
                    ],
                    ),
                  Row(children: <Widget>[
                    IconButton(
                      icon: Icon(
                        MdiIcons.chatProcessing,
                        color: corPrimaria,
                        ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                              user: user,
                              sala: null,
                              )));
                      },
                      ),
                   PopupMenuButton<int>(
                      icon: Icon(
                        Icons.more_vert,
                        color: corPrimaria,
                        ),
                      onSelected: (int result) {
                        switch (result) {
                          case 1:
                          ConvidarUsuario(user,isAproving: true);
                          mc.removerParticipante(widget.s,user.id);
                            break;
                          case 2:
                            mc.removerParticipante(widget.s,user.id);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                     <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text('Adicionar Ao Grupo'
                            ),
                          ),
                        PopupMenuItem<int>(
                          value: 2,
                          child:Text('Negar Participação')
                          ),
                      ])

                  ]),
                ],
                ),
            ],
            ),
          ));
  }

  Widget UserListItem(User user) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              user.foto != null
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(user.foto),
                      minRadius: 12,
                      maxRadius: 25,
                    )
                  : CircleAvatar(
                      minRadius: 12,
                      maxRadius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(
                        user.genero == 'Masculino'
                            ? MdiIcons.humanMale
                            : MdiIcons.humanFemale,
                        color: user.genero == 'Masculino'
                            ? Colors.blueAccent
                            : Colors.pink,
                        size: 25,
                      ),
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user.nome.length > 15
                        ? user.nome.substring(0, 15) + '...'
                        : user.nome,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .045,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  user.isGroupAdm
                      ? Text(
                          'Administrador',
                          style: TextStyle(color: corPrimaria, fontSize: 10),
                        )
                      : Container(),
                ],
              ),
              Row(children: <Widget>[
                IconButton(
                  icon: Icon(
                    MdiIcons.chatProcessing,
                    color: corPrimaria,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                              user: user,
                              sala: null,
                            )));
                  },
                ),
                Helper.localUser.isPrestador
                    ? PopupMenuButton<int>(
                        icon: Icon(
                          Icons.more_vert,
                          color: corPrimaria,
                        ),
                        onSelected: (int result) {
                          //dToast('TODO Remover');
                          switch (result) {
                            case 1:
                              if (user.isGroupAdm) {
                                widget.s.meta[user.id]['isAdm'] = false;
                                chatRef
                                    .document(widget.s.id)
                                    .updateData(widget.s.toJson())
                                    .then((v) {
                                  dToast(
                                      'Privilegios de Administrador Removidos');
                                  Navigator.of(context).pop();
                                });
                              } else {
                                widget.s.meta[user.id]['isAdm'] = true;
                                chatRef
                                    .document(widget.s.id)
                                    .updateData(widget.s.toJson())
                                    .then((v) {
                                  dToast(
                                      'Privilegios de Administrador Adicionados');
                                  Navigator.of(context).pop();
                                });
                              }
                              break;
                            case 2:
                              List membros = widget.s.membros;
                              membros = membros.toSet().toList(growable: true);
                              membros.remove(user.id);
                              widget.s.membros = membros;
                              widget.s.meta.remove(user.id);
                              chatRef
                                  .document(widget.s.id)
                                  .updateData(widget.s.toJson())
                                  .then((v) {
                                dToast('Usuario Removido');
                                Navigator.of(context).pop();
                              });
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            widget.s.meta[Helper.localUser.id]['isAdm']
                                ? <PopupMenuEntry<int>>[
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text(
                                        user.isGroupAdm
                                            ? 'Remover como Administrador'
                                            : 'Tornar Administrador',
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: user.id == Helper.localUser.id
                                          ? Text('Sair Do Grupo')
                                          : Text('Remover Do Grupo'),
                                    ),
                                  ]
                                : <PopupMenuEntry<int>>[
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text(
                                        user.isGroupAdm
                                            ? 'Remover como Administrador'
                                            : 'Tornar Administrador',
                                      ),
                                    ),
                                  ],
                      )
                    : user.id == Helper.localUser.id
                        ? PopupMenuButton<int>(
                            icon: Icon(
                              Icons.more_vert,
                              color: corPrimaria,
                            ),
                            onSelected: (int result) {
                              switch (result) {
                                case 1:
                                  if (user.isGroupAdm) {
                                    widget.s.meta[user.id]['isAdm'] = false;
                                    chatRef
                                        .document(widget.s.id)
                                        .updateData(widget.s.toJson())
                                        .then((v) {
                                      dToast(
                                          'Privilegios de Administrador Removidos');
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    widget.s.meta[user.id]['isAdm'] = true;
                                    chatRef
                                        .document(widget.s.id)
                                        .updateData(widget.s.toJson())
                                        .then((v) {
                                      dToast(
                                          'Privilegios de Administrador Adicionados');
                                      Navigator.of(context).pop();
                                    });
                                  }
                                  break;
                                case 2:
                                  List membros = widget.s.membros;
                                  membros =
                                      membros.toSet().toList(growable: true);
                                  membros.remove(user.id);
                                  widget.s.membros = membros;
                                  widget.s.meta.remove(user.id);
                                  chatRef
                                      .document(widget.s.id)
                                      .updateData(widget.s.toJson())
                                      .then((v) {
                                    dToast('Usuario Removido');
                                    Navigator.of(context).pop();
                                  });
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: user.id == Helper.localUser.id
                                        ? Text('Sair Do Grupo')
                                        : Text('Remover Do Grupo'),
                                  ),
                                ])
                        : Container()
              ]),
            ],
          ),
        ],
      ),
    ));
  }
}
