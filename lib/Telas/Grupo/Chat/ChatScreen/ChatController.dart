import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:autooh/Helpers/BadgerController.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Message.dart';
import 'package:autooh/Objetos/Notificacao.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../main.dart';


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

  ChatController(User u, bool isI, String salaId, String s) {
    inHide.add(false);
    if (s == null) {
      this.user = u;
      this.isIndividual = isI;
      if (isIndividual) {
        //print('INICIANDO ${user.id}');
        chatRef
            .where('membros', arrayContains: Helper.localUser.id)
            .where('isPrivate', isEqualTo: isIndividual)
            .getDocuments()
            .then((v) {
          //print('CHEGOU AQUI');
          if (v.documents.length != 0) {
            bool contains = false;
            for (var j in v.documents) {
              Sala s = new Sala.fromJson(j.data);
              //print('LOOPANDO ${s.toString()}');
              for (var m in s.membros) {
                if (m.toString() == user.id) {
                  //print('ACHOU AQUI ${s.membros.toString()}');
                  if (s.isPrivate) {
                    contains = true;
                    // print('AQUI SALA ${s.toString()}');

                    if (s.meta[Helper.localUser.id] != null) {
                      bc.removeBadges(0,
                          value: s.meta[Helper.localUser.id]['NonRead']);
                      s.meta[Helper.localUser.id]['NonRead'] = 0;
                    }
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
            }
            if (!contains) {
              String salaid = randomAlpha(20);
              //TODO Criar SALA
              sala = new Sala(
                  created_at: DateTime.now(),
                  updated_at: DateTime.now(),
                  isPrivate: isIndividual,
                  membros: [Helper.localUser.id, user.id],
                  lastMessage: null,
                  sala: salaid,
                  meta: {
                    Helper.localUser.id: {
                      'foto': user.foto == null
                          ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                          : user.foto,
                      'NonRead': 0,
                      'partnerName': user.nome,
                    },
                    user.id: {
                      'foto': Helper.localUser.foto == null
                          ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                          : Helper.localUser.foto,
                      'NonRead': 0,
                      'partnerName': Helper.localUser.nome,
                    }
                  },
                  deleted_at: null,
                  id: null);
              chatRef.add(sala.toJson()).then((v) {
                sala.id = v.documentID;
                chatRef.document(sala.id).updateData(sala.toJson()).then((vv) {
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
                membros: [Helper.localUser.id, user.id],
                lastMessage: null,
                sala: salaid,
                meta: {
                  Helper.localUser.id: {
                    'foto': user.foto == null
                        ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                        : user.foto,
                    'NonRead': 0,
                    'partnerName': user.nome,
                  },
                  user.id: {
                    'foto': Helper.localUser.foto == null
                        ? 'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7'
                        : Helper.localUser.foto,
                    'NonRead': 0,
                    'partnerName': Helper.localUser.nome,
                  }
                },
                deleted_at: null,
                id: null);
            chatRef.add(sala.toJson()).then((v) {
              sala.id = v.documentID;
              chatRef.document(sala.id).updateData(sala.toJson()).then((vv) {
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
        chatRef.where('sala', isEqualTo: salaId).getDocuments().then((v) {
          if (v.documents.length != 0) {
            sala = Sala.fromJson(v.documents[0].data);
            inSala.add(sala);
            if (reference == null) {
              reference = FirebaseDatabase.instance
                  .reference()
                  .child('Chats')
                  .child('${sala.sala}');
            }
          } else {
            String salaid = randomAlpha(20);
            //TODO Criar SALA
            sala = new Sala(
                created_at: DateTime.now(),
                updated_at: DateTime.now(),
                isPrivate: isIndividual,
                membros: [Helper.localUser.id, user.id],
                lastMessage: null,
                sala: salaid,
                deleted_at: null,
                id: null);
            chatRef.add(sala.toJson()).then((v) {
              sala.id = v.documentID;
              chatRef.document(sala.id).updateData(sala.toJson()).then((vv) {
                // print ('Sala Criada');

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
      }
    } else {
      chatRef.document(s).get().then((v) {
        if (v.data != null) {
          sala = Sala.fromJson(v.data);
          inSala.add(sala);
          if (reference == null) {
            reference = FirebaseDatabase.instance
                .reference()
                .child('Chats')
                .child('${sala.sala}');
          }
        }
      }).catchError((err) {
        print('Error:${err.toString()}');
      });
    }
  }
  void sendMessage({String text, String imageUrl}) {
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
      //print('Sala atualizada');
      inSala.add(sala);
    });

    //TODO ARRUMAR SEND NOTIFICATION
    sendNotificationUsuario(text, imageUrl);

    Helper.analytics.logEvent(name: 'send_message');
  }

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

  @override
  void dispose() {
    // TODO: implement dispose
    salaController.close();
  }
}
