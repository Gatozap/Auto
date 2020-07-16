import 'dart:convert';

import 'package:autooh/Objetos/Notificacao.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class CampanhaController extends BlocBase {
  BehaviorSubject<Campanha> _controllerCampanha = new BehaviorSubject<Campanha>();
  Stream<Campanha> get outCampanha => _controllerCampanha.stream;
  Sink<Campanha> get inCampanha => _controllerCampanha.sink;
  Campanha campanha;

  CampanhaController({this.campanha});
  Future EditarCampanha(Campanha campanha) async {

    if (campanha.fotos != null) {
      if (campanha.fotos.length != 0) {
        for (int i = 0; i < campanha.fotos.length; i++) {
          if (!campanha.fotos[i].contains('http')) {
            String fotoUrl = await Helper().uploadPicture(campanha.fotos[i]);
            if (fotoUrl != null) {
              campanha.fotos[i] = fotoUrl;
            }
          }
        }
      }
    }
      return campanhasRef.document(campanha.id).updateData(campanha.toJson()).then((d) {
        print('editado com sucesso');

        return campanha;
      }).catchError((err) {
        print('Error: ${err}');
        return err;
      });


  }


  Future CriarCampanha({Campanha campanha}){
        return campanhasRef.add(campanha.toJson()).then((v){
          campanha.id = v.documentID;

          campanhasRef.document(campanha.id).updateData(campanha.toJson()).then((v){
            dToast('Campanha cadastrada com sucesso');
            sendNotification('Uma nova campanha está disponivel!','${campanha.nome}',null,'global',campanha, campanha.id,);
          }).catchError((err) {
            print('aqui erro 1 ${err}');
            return null;
          });
        }).catchError((err) {
          print('aqui erro 2 ${err}');
          return null;
        });
 }

  String notificationUrl =
      'https://us-central1-avanticar-34239.cloudfunctions.net/sendNotification';
  sendNotification(title, text, imageUrl, topic, campanha, solicitacao,
      {behavior = 1}) async {
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
        title: '${title}',
        message: '${text}!',
        behaivior: 1,
        sended_at: DateTime.now(),
        sender: 'user${Helper.localUser.id.toString()}',
        topic: topic,
        data: json.encode({
          'campanha': campanha,
          'solicitacao': solicitacao,
          'user': Helper.localUser.toJson(),
          'title': '${title}',
          'message': '${text}',
          'behaivior': behavior,
          'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'user${Helper.localUser.id.toString()}',
          //'topic': 'estabelecimento${estabelecimento.mercado_id}';
        }));
    n.image = imageUrl == null ? null : imageUrl;

    http.post(notificationUrl, body: n.toJson()).then((v) {
      //print(v.body);
      print('ENVIOU NOTIFICAÇÂO ${n.toString()}');
      notificacoesRef.add(n.toJson());
    }).catchError((e) {
      print('Err:' + e.toString());
    });
  }

  @override
  void dispose() {
    _controllerCampanha.close();
    // TODO: implement dispose
  }

}