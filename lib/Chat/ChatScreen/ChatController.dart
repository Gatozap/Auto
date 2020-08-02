import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Helpers.dart';
import 'package:autooh/Helpers/References.dart';

import 'package:autooh/Objetos/Message.dart';
import 'package:autooh/Objetos/Notificacao.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/rxdart.dart';

class ChatController extends BlocBase {
  DatabaseReference reference;
  User user;
  bool isIndividual;
  BehaviorSubject<Sala> salaController = new BehaviorSubject<Sala>();
  Stream<Sala> get outSala => salaController.stream;
  Sink<Sala> get inSala => salaController.sink;
  BehaviorSubject<bool> hideController = new BehaviorSubject<bool>();
  Stream<bool> get outHide => hideController.stream;
  Sink<bool> get inHide => hideController.sink;
  Sala sala;
  bool isFromHome;

  ChatController(

    this.sala, {this. isFromHome = false, User user}

  ) {
    inHide.add(false);
    if(isFromHome){
      chatRef
          .where('membros', arrayContains: '${Helper.localUser.id}')
          .where('isPrivate', isEqualTo: isIndividual)
          .getDocuments()
          .then((v) {
        print('CHEGOU AQUI SALALALALAL');
        if (v.documents.length != 0) {
          bool contains = false;
          for (var j in v.documents) {
            Sala s = new Sala.fromJson(j.data);
            print('SALA LOOPANDO ${s.toString()}');
            for (var m in s.membros) {
              print('AQUI MEMBRO ${m}');
              if ('${m.toString()}' == '${Helper.localUser.id.toString()}') {
                //print('ACHOU AQUI ${s.membros.toString()}');
                  contains = true;
                  // print('AQUI SALA ${s.toString()}');

                  sala = s;
                  inSala.add(sala);
                  chatRef
                      .document(sala.id)
                      .updateData(sala.toJson())
                      .then((v) {
                    // print('Atualizou NonReads');
                  });
                  // print('Sala Encontrada ${sala.toString()}');
                  if (reference == null) {
                    reference = FirebaseDatabase.instance
                        .reference()
                        .child('Chats')
                        .child('${sala.sala}');
                  }
              }
            }
          }
          if (!contains) {
            String salaid = randomAlpha(20);
            //TODO Criar SALA
            sala = new Sala(
                created_at: DateTime.now(),
                updated_at: DateTime.now(),
                isPrivate: isIndividual,
                membros: ['suporte', Helper.localUser.id],
                lastMessage: null,
                sala: salaid,
                meta: {
                  Helper.localUser.id: {
                    'foto': Helper.localUser.foto == null
                        ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                        : Helper.localUser.foto,
                    'NonRead': 0,
                    'partnerName': Helper.localUser.nome,
                  },
                  'suporte': {
                    'foto':
                    'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png',
                    'NonRead': 0,
                    'partnerName': 'Suporte',
                  }
                },
                deleted_at: null,
                id: null);
            chatRef.add(sala.toJson()).then((v) {
              sala.id = v.documentID;
              chatRef
                  .document(sala.id)
                  .updateData(sala.toJson())
                  .then((vv) {
                //print('Sala Criada ${sala.toString()}');

                inSala.add(sala);
                if (reference == null) {
                  reference = FirebaseDatabase.instance
                      .reference()
                      .child('Chats')
                      .child('${sala.sala}');
                }
              }).catchError((err) {
                print('Error:${err.toString()}');
              });
            }).catchError((err) {
              print('Error:${err.toString()}');
            });
          }
        } else {
          String salaid = randomAlpha(20);
          //TODO Criar SALA
          sala = new Sala(
              created_at: DateTime.now(),
              updated_at: DateTime.now(),
              isPrivate: isIndividual,
              membros: ['suporte', Helper.localUser.id],
              lastMessage: null,
              sala: salaid,
              meta: {
                Helper.localUser.id: {
                  'foto': Helper.localUser.foto == null
                      ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                      : Helper.localUser.foto,
                  'NonRead': 0,
                  'partnerName': Helper.localUser.nome,
                },
                'suporte': {
                  'foto':
                  'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png',
                  'NonRead': 0,
                  'partnerName': 'Suporte',
                }
              },
              deleted_at: null,
              id: null);
          chatRef.add(sala.toJson()).then((v) {
            sala.id = v.documentID;
            chatRef.document(sala.id).updateData(sala.toJson()).then((
                vv) {
              // print('Sala Criada');

              inSala.add(sala);
              if (reference == null) {
                reference = FirebaseDatabase.instance
                    .reference()
                    .child('Chats')
                    .child('${sala.sala}');
              }
            }).catchError((err) {
              print('Error:${err.toString()}');
            });
          }).catchError((err) {
            print('Error:${err.toString()}');
          });
        }
      });
    } else {

      if(user != null){
        chatRef
            .where('membros', arrayContains: '${user.id}')
            .where('isPrivate', isEqualTo: isIndividual)
            .getDocuments()
            .then((v) {
          print('CHEGOU AQUI SALALALALAL');
          if (v.documents.length != 0) {
            bool contains = false;
            for (var j in v.documents) {
              Sala s = new Sala.fromJson(j.data);
              print('SALA LOOPANDO ${s.toString()}');
              for (var m in s.membros) {
                print('AQUI MEMBRO ${m}');
                if ('${m.toString()}' == '${user.id.toString()}') {
                  //print('ACHOU AQUI ${s.membros.toString()}');
                  contains = true;
                  // print('AQUI SALA ${s.toString()}');

                  sala = s;
                  inSala.add(sala);
                  chatRef
                      .document(sala.id)
                      .updateData(sala.toJson())
                      .then((v) {
                    // print('Atualizou NonReads');
                  });
                  // print('Sala Encontrada ${sala.toString()}');
                  if (reference == null) {
                    reference = FirebaseDatabase.instance
                        .reference()
                        .child('Chats')
                        .child('${sala.sala}');
                  }
                }
              }
            }
            if (!contains) {
              String salaid = randomAlpha(20);
              //TODO Criar SALA
              sala = new Sala(
                  created_at: DateTime.now(),
                  updated_at: DateTime.now(),
                  isPrivate: isIndividual,
                  membros: ['suporte', user.id],
                  lastMessage: null,
                  sala: salaid,
                  meta: {
                    user.id: {
                      'foto':user.foto == null
                          ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                          : user.foto,
                      'NonRead': 0,
                      'partnerName': user.nome,
                    },
                    'suporte': {
                      'foto':
                      'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png',
                      'NonRead': 0,
                      'partnerName': 'Suporte',
                    }
                  },
                  deleted_at: null,
                  id: null);
              chatRef.add(sala.toJson()).then((v) {
                sala.id = v.documentID;
                chatRef
                    .document(sala.id)
                    .updateData(sala.toJson())
                    .then((vv) {
                  //print('Sala Criada ${sala.toString()}');

                  inSala.add(sala);
                  if (reference == null) {
                    reference = FirebaseDatabase.instance
                        .reference()
                        .child('Chats')
                        .child('${sala.sala}');
                  }
                }).catchError((err) {
                  print('Error:${err.toString()}');
                });
              }).catchError((err) {
                print('Error:${err.toString()}');
              });
            }
          } else {
            String salaid = randomAlpha(20);
            //TODO Criar SALA
            sala = new Sala(
                created_at: DateTime.now(),
                updated_at: DateTime.now(),
                isPrivate: isIndividual,
                membros: ['suporte', Helper.localUser.id],
                lastMessage: null,
                sala: salaid,
                meta: {
                  Helper.localUser.id: {
                    'foto': Helper.localUser.foto == null
                        ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                        : Helper.localUser.foto,
                    'NonRead': 0,
                    'partnerName': Helper.localUser.nome,
                  },
                  'suporte': {
                    'foto':
                    'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png',
                    'NonRead': 0,
                    'partnerName': 'Suporte',
                  }
                },
                deleted_at: null,
                id: null);
            chatRef.add(sala.toJson()).then((v) {
              sala.id = v.documentID;
              chatRef.document(sala.id).updateData(sala.toJson()).then((
                  vv) {
                // print('Sala Criada');

                inSala.add(sala);
                if (reference == null) {
                  reference = FirebaseDatabase.instance
                      .reference()
                      .child('Chats')
                      .child('${sala.sala}');
                }
              }).catchError((err) {
                print('Error:${err.toString()}');
              });
            }).catchError((err) {
              print('Error:${err.toString()}');
            });
          }
        });
      }else {
        reference = FirebaseDatabase.instance
            .reference()
            .child('Chats')
            .child('${sala.sala}');
        inSala.add(sala);
      }
    }
  }

  updateMessage(Message m, id) {
    reference.child(id).update(m.toJson());
  }

  void sendMessage(
      {String text, String imageUrl, bool isContratacao, User user}) {
    Message msg;
    if (imageUrl != null) {
      msg = Message(
          msg: text,
          imgUrl: imageUrl,
          senderName: !isFromHome
              ? 'Suporte Autooh'
              : Helper.localUser.nome,
          senderFoto: !isFromHome
              ? 'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png'
              : Helper.localUser.foto,
          senderId: Helper.localUser.id.toString(),
          timestamp: DateTime.now());
    } else {
      msg = Message(
          msg: text,
          imgUrl: null,
          senderName: !isFromHome
              ? 'Suporte Autooh'
              : Helper.localUser.nome,
          senderFoto: !isFromHome
              ? 'https://autooh.com.br/wp-content/uploads/2020/05/logotipo.png'
              : Helper.localUser.foto,
          senderId: Helper.localUser.id.toString(),
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
      //print('Sala atualizada');
      inSala.add(sala);
    });

    //TODO ARRUMAR SEND NOTIFICATION
    sendNotificationUsuario(text, imageUrl, user);

    analytics.logEvent(name: 'send_message');
  }

  sendNotificationUsuario(text, imageUrl, User user) async {
    /* 'title': '${Helpers.user.nome} Apoiou o protocolo ${post.titulo}',
      'responsavel': json.encode(Helpers.user),
      'tipo': 0.toString(),
      'sujeito': post.id.toString(),
      'topic': 'protocoloteste' + post.id.toString(),
      'foto': Helpers.user.foto == null
          ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
          : Helpers.user.foto,
      'data': DateTime.now().millisecondsSinceEpoch.toString(),*/
    String usuario = '';
    for (var m in sala.membros) {
      if (m != 'suporte') {
        usuario = m;
      }
    }
    Notificacao n = new Notificacao(
        title: '${text}',
        message: '${!isFromHome? 'Suporte Autooh' :Helper.localUser.nome} enviou uma mensagem',
        behaivior: 1,
        sended_at: DateTime.now(),
        sender: 'user${Helper.localUser.id.toString()}',
        topic: !isFromHome? 'user${usuario}':'Administrador',
        data: json.encode({
          'campanha': '',
          'solicitacao': '',
          'user': Helper.localUser.toJson(),
          'sala': sala.id,
          'title': '${text}',
          'message': '${!isFromHome? 'Suporte Autooh' :Helper.localUser.nome} enviou uma mensagem',
          'behaivior': 1,
          'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'user${Helper.localUser.id.toString()}',
          'topic': !isFromHome? 'user${usuario}':'Administrador'
        }));

    n.image = imageUrl == null ? null : imageUrl;

    http.post(notificationUrl, body: n.toJson()).then((v) {
      //print(v.body);
      print('ENVIOU NOTIFICAÇÂO');
      notificacoesRef.add(n.toJson());
    }).catchError((e) {
      print('Err:' + e.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    salaController.close();
  }
}
