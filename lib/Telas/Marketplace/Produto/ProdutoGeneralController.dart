import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Estoque.dart';
import 'package:bocaboca/Objetos/Notificacao.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/ProdutoPedido.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';

String lugar = 'ProdutoGeneralController';

Future AdicionarProdutoAoCarrinho({String user, ProdutoPedido produto}) async {
  prestadorRef.document(Helper.localUser.prestador).get().then((v) {
    Prestador c = Prestador.fromJson(v.data);
    if (c.isEstoque) {
      estoquesRef
          .where('prestador', isEqualTo: Helper.localUser.prestador)
          .where('produto', isEqualTo: produto.produto)
          .getDocuments()
          .then((v) async {
        if (v.documents.length != 0) {
          Estoque e = Estoque.fromJson(v.documents[0].data);
          if ((e.disponivel - produto.quantidade) < e.minimo) {
            DocumentSnapshot ds = await produtosRef.document(e.produto).get();
            Produto p = Produto.fromJson(ds.data);
            sendNotificationSemEstoque(
                'Sem estoque',
                'Estao interessados no produto ${p.titulo}',
                p.fotos != null ? p.fotos[0] : null,
                Helper.localUser.prestador,
                user);
          }
        }
      });
    }
  });
  var carrinhoRT =
      FirebaseDatabase.instance.reference().child('Carrinhos').child('${user}');
  bool isProductArealyThere = false;
  var data = await carrinhoRT.child(produto.produto).once();
  isProductArealyThere = data.value != null;
  return carrinhoRT.child(produto.produto).set(produto.toJson()).then((v) {
    !isProductArealyThere ? updateCounter(user: user) : () {};
    return 'ok';
  }).catchError((err) => Err(err, lugar));
}

Future LimparCarrinho({String user}) {
  var carrinhoRT =
      FirebaseDatabase.instance.reference().child('Carrinhos').child('${user}');
  return carrinhoRT.set(null).then((v) {
    updateCounter(user: user, value: 0);
    return 'ok';
  }).catchError((err) => Err(err, lugar));
}

DatabaseReference GetCarrinho({String user}) {
  DatabaseReference carrinhoRT =
      FirebaseDatabase.instance.reference().child('Carrinhos').child('${user}');

  return carrinhoRT;
}

Future RemoverProdutoCarrinho({String user, ProdutoPedido produto}) {
  var carrinhoRT =
      FirebaseDatabase.instance.reference().child('Carrinhos').child('${user}');
  updateCounter(user: user, decreasse: true);
  return carrinhoRT.child(produto.produto).remove().then((v) {
    return 'ok';
  }).catchError((err) => Err(err, lugar));
}

updateCounter({String user, int value, bool decreasse = false}) {
  var ccRT = FirebaseDatabase.instance
      .reference()
      .child('CarrinhoCounter')
      .child('${user}');
  if (value == null) {
    return ccRT.once().then((v) {
      int counter = v.value == null ? 0 : v.value;
      !decreasse ? counter++ : counter--;
      ccRT.set(counter);
    }).catchError((err) => Err(err, lugar));
  } else {
    return ccRT.set(value).then((v) {
      return 'ok';
    }).catchError((err) => Err(err, lugar));
  }
}

class CarrinhoCountController extends BlocBase {
  int count;
  BehaviorSubject<int> countController = BehaviorSubject<int>();

  Stream<int> get outCount => countController.stream;

  Sink<int> get inCount => countController.sink;

  CarrinhoCountController(String user) {
    inCount.add(0);
    var ccRT = FirebaseDatabase.instance
        .reference()
        .child('CarrinhoCounter')
        .child('${user}');

    ccRT.once().then((v) {
      count = v.value == null ? 0 : v.value;
      inCount.add(count);
    }).catchError((err) => Err(err, lugar));
    ccRT.onValue.listen((v) {
      print('ENTROU AQUI CHILD');
      count = v.snapshot.value == null ? 0 : v.snapshot.value;
      inCount.add(count);
    }).onError((err) => Err(err, lugar));
  }

  @override
  void dispose() {
    countController.close();
    // TODO: implement dispose
  }
}

sendNotificationAdicionarAoCarrinhoUsuario(
    text, String subtext, imageUrl, String id, String carrinho) async {
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
      title: '${text}',
      message: subtext,
      behaivior: 4,
      sended_at: DateTime.now(),
      sender: Helper.localUser.id,
      topic: id,
      data: json.encode({
        'carrinho': carrinho,
        'user': Helper.localUser.toJson(),
        'title': '${text}',
        'message': subtext,
        'behaivior': 4,
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

sendNotificationSemEstoque(
    text, String subtext, imageUrl, String id, String carrinho) async {
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
      title: '${text}',
      message: subtext,
      behaivior: 4,
      sended_at: DateTime.now(),
      sender: Helper.localUser.id,
      topic: id,
      data: json.encode({
        'carrinho': carrinho,
        'user': Helper.localUser.toJson(),
        'title': '${text}',
        'message': subtext,
        'behaivior': 5,
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
