import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Objetos/Estoque.dart';
import 'package:autooh/Objetos/Notificacao.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../main.dart';

class CadastrarProdutoController extends BlocBase {
  BehaviorSubject<Produto> _controllerProduto = new BehaviorSubject<Produto>();
  Stream<Produto> get outProduto => _controllerProduto.stream;

  Sink<Produto> get inProduto => _controllerProduto.sink;
  Produto produto;
  String lastcep;


  CadastrarProdutoController({this.produto}){if(produto == null){
    produto = new Produto(segunda: true, terca: true, quarta: true, quinta: true, sexta: true, sabado: false, domingo: false);
  }
  inProduto.add(produto);
  }
  

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerProduto.close();
  }

  Future CadastrarProduto(Produto produto) async {
    if (produto.fotos != null) {
      if (produto.fotos.length != 0) {
        for (int i = 0; i < produto.fotos.length; i++) {
          String fotoUrl = await Helper().uploadPicture(produto.fotos[i]);
          if (fotoUrl != null) {
            produto.fotos[i] = fotoUrl;
          }
        }
      }
    }
    produto.visivel = true;
    return produtosRef.add(produto.toJson()).then((v) {
      produto.id = v.documentID;
      return produtosRef
          .document(v.documentID)
          .updateData(produto.toJson())
          .then((d) {
        print('cadastrado com sucesso');

        sendNotificationProduto(produto);
        prestadorRef.document(Helper.localUser.prestador).get().then((v) {
          Prestador c = Prestador.fromJson(v.data);
          if (c.isEstoque) {
            Estoque e = Estoque(
                produto: produto.id,
                last_purchased_at: null,
                minimo: 0,
                disponivel: 100,
                prestador: Helper.localUser.prestador,
                created_at: DateTime.now(),
                updated_at: DateTime.now(),
                deleted_at: null,
                isHerbaLife: false);
            estoquesRef.add(e.toJson()).then((v) {
              print('Criou Produto no Estoque');
              e.id = v.documentID;
              estoquesRef.document(e.id).updateData(e.toJson()).then((v) {
                print('Atualizou o id ${e.id}');
              });
            });
          }
        });
        return produto;
      }).catchError((err) {
        print('Error: ${err}');
        return err;
      });
      ;
    }).catchError((err) {
      print('Error: ${err}');
      return err;
    });
    ;
  }
  Future EditarProduto(Produto produto) async {

    if (produto.fotos != null) {
      if (produto.fotos.length != 0) {
        for (int i = 0; i < produto.fotos.length; i++) {
          if(!produto.fotos[i].contains('http')){

            String fotoUrl = await Helper().uploadPicture(produto.fotos[i]);
            if (fotoUrl != null) {
              produto.fotos[i] = fotoUrl;
            }
          }

        }
      }
      produto.visivel = true;

      return produtosRef
          .document(produto.id)
          .updateData(produto.toJson())
          .then((d) {
        print('editado com sucesso');

        return produto;
      }).catchError((err) {
        print('Error: ${err}');
        return err;
      });


    }
  }

}


sendNotificationProduto(Produto produto) async {
  String topic = 'Clientes${Helper.localUser.prestador}';

  topic = Helper.localUser
      .prestador; //DESCOMENTAR ESSA LINHA PRA MANDAR AS PUSHS PARA OS COACHS EM VEZ DOS CLIENTES

  print('INICIANDO NOTIFICAÇÃO');
  Notificacao n = new Notificacao(
      title: '${produto.titulo} Está a venda!',
      message: '${produto.descricao}',
      behaivior: 2,
      sended_at: DateTime.now(),
      sender: Helper.localUser.prestador,
      topic: topic,
      data: json.encode({
        'user': Helper.localUser.toJson(),
        'title': '${produto.titulo} Está a venda!',
        'message': '${produto.descricao}',
        'produto': produto.toJson(),
        'behaivior': 2,
        'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': Helper.localUser.id,
        'topic': topic,
      }));
  n.image = produto.fotos == null
      ? null
      : produto.fotos[0] != null ? produto.fotos[0] : null;

  http.post(notificationUrl, body: n.toJson()).then((v) {
    print('NOTIFICOU');
    print(v.body);
  }).catchError((e) {
    print('Err:' + e.toString());
  });
}
