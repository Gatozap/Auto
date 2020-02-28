import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:rxdart/subjects.dart';

class ProdutoListController extends BlocBase {
  List<Produto> produtos;
  BehaviorSubject<List<Produto>> produtosController =
      BehaviorSubject<List<Produto>>();
  Stream<List<Produto>> get outProdutos => produtosController.stream;
  Sink<List<Produto>> get inProdutos => produtosController.sink;

  BehaviorSubject<bool> tipoController =
  BehaviorSubject<bool>();
  Stream<bool> get outTipo => tipoController.stream;
  Sink<bool> get inTipo => tipoController.sink;
  ProdutoListController() {
    showProdutos();
  }

  void showProdutos(){
    inTipo.add(true);
    produtos = new List();
    inProdutos.add(produtos);
        produtosRef
            .where('visivel', isEqualTo: true)
            .snapshots()
            .listen((snap) {
          if (snap.documents.length != 0) {
              produtos = new List();
            for (var j in snap.documents) {
              bool contains = false;
              Produto p = new Produto.fromJson(j.data);
              p.id = j.documentID;
              for(Produto prod in produtos){
                if(prod.id == p.id){
                  contains = true;
                }
              }
              if(!contains) {
                produtos.add(p);
              }
            }

            produtos.sort((Produto a, Produto b) => b
                .created_at.millisecondsSinceEpoch
                .compareTo(a.created_at.millisecondsSinceEpoch));

            inProdutos.add(produtos);
          }
        }).onError((err) {
          print('Error :${err.toString()}');
        });
  }




  @override
  void dispose() {
    produtosController.close();
    tipoController.close();
    // TODO: implement dispose
  }

}
