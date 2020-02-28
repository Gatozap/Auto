import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoPageController extends BlocBase {
  BehaviorSubject<Produto> controllerProduto = BehaviorSubject<Produto>();
  Stream<Produto> get outProduto => controllerProduto.stream;
  Sink<Produto> get inProduto => controllerProduto.sink;

  BehaviorSubject<User> userController = BehaviorSubject<User>();
  Stream<User> get outUser => userController.stream;
  Sink<User> get inUser => userController.sink;
  Produto produto;
  User user;

  ProdutoPageController(this.produto) {
    produtosRef.document(produto.id).snapshots().listen((v) {
      produto = Produto.fromJson(v.data);
      produto.id = v.documentID;
      inProduto.add(produto);
    });
    userRef.document(produto.criador).get().then((v) {
      user = User.fromJson(v.data);
      user.id = v.documentID;
      inUser.add(user);
    });
  }

  @override
  void dispose() {
    controllerProduto.close();
    userController.close();
  }
}
