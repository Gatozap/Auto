
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Estoque.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/CadastrarProduto/CadastrarProdutoController.dart';
import 'package:rxdart/rxdart.dart';

class EditarProdutoController extends BlocBase {
  BehaviorSubject<Produto> editarprodutoController = new BehaviorSubject<Produto>();

  EditarProdutoController({this.produto}){if(produto == null){
    produto = new Produto(segunda: true, terca: true, quarta: true, quinta: true, sexta: true, sabado: false, domingo: false);
  }
  inProduto.add(produto);
  }

  Stream<Produto> get outProduto => editarprodutoController.stream;

  Sink<Produto> get inProduto => editarprodutoController.sink;
  Produto produto;

  Future EditarProduto(Produto produto) async {
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

Future<String> updateProduto(Produto produto) async {
  if (produto != null) {
    return produtosRef.document(produto.id).updateData(produto.toJson()).then((v) {
      inProduto.add(produto);
      
      return 'Atualizado com sucesso!';
    }).catchError((err) {
      print('Error: ${err}');
      return 'Error: ${err}';
    });
  } else {
    return Future.delayed(Duration(seconds: 1)).then((v) {
      return 'Erro: Usuário Nulo';
    });
  }
}

  @override
  void dispose() {
    editarprodutoController.close();
    // TODO: implement dispose
  }
}