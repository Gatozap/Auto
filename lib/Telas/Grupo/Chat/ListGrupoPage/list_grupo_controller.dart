import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Notificacao.dart';
import 'package:bocaboca/Objetos/Sala.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';


class ListGrupoController extends BlocBase{
  BehaviorSubject<List<Sala>> gruposController = BehaviorSubject<List<Sala>>();
  Stream<List<Sala>> get outGrupos => gruposController.stream;
  Sink<List<Sala>> get inGrupos=> gruposController.sink;
  List<Sala> salas = new List();


  ListGrupoController(){
   BuscarSalas();
  }

  void BuscarSalas(){
    List<Sala> salas = new List();
    inGrupos.add(salas);
    chatRef.where('isPrivate',isEqualTo: false).snapshots().listen((v){
      for(var i in v.documents){
        Sala s = Sala.fromJson(i.data);
        bool contains = false;
        if(s.membros != null) {
          for (String m in s.membros) {
            if (m == Helper.localUser.id) {
              contains = true;
            }
          }
        }
        if(s.pedidos != null) {
          for (String m in s.pedidos) {
            if (m == Helper.localUser.id) {
              contains = true;
            }
          }
        }
        if(!contains){
          salas.add(s);
        }
        inGrupos.add(salas);
      }
    });
  }

  @override
  void dispose() {
    gruposController.close();
  }

  void askToJoin(Sala s) {
    chatRef.document(s.id).updateData(s.toJson()).then((v){
      sendNotificationUsuario(s, null);
    });
  }

  sendNotificationUsuario(Sala s, imageUrl) async {
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
    //TODO Notificação;
    Notificacao n = new Notificacao(
        title: '${Helper.localUser.nome} pediu para participar do Grupo ${s.name}',
        message: '${Helper.localUser.nome} pediu para participar do Grupo ${s.name}',
        behaivior: 0,
        sended_at: DateTime.now(),
        sender: Helper.localUser.id,
        topic: s.id,
        data: json.encode({
                            'sala': s.id,
                            'user': Helper.localUser.toJson(),
                            'title': '${Helper.localUser.nome} pediu para participar do Grupo ${s.name}',
                            'message': '${Helper.localUser.nome} pediu para participar do Grupo ${s.name}',
                            'behaivior': 0,
                            'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
                            'sender': Helper.localUser.id,
                            'topic': s.id,
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



}