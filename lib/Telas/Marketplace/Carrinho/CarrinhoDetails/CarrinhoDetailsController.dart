import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/ProdutoPedido.dart';
import 'package:rxdart/rxdart.dart';

class CarrinhoDetailsController extends BlocBase {
  List<ProdutoPedido> produtosPedidos;
  BehaviorSubject<List<ProdutoPedido>> produtosPedidosController =
      BehaviorSubject<List<ProdutoPedido>>();

  Stream<List<ProdutoPedido>> get outprodutosPedidos =>
      produtosPedidosController.stream;

  Sink<List<ProdutoPedido>> get inprodutosPedidos =>
      produtosPedidosController.sink;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
