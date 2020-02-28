import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class AddProdutoController implements BlocBase {
  int quantidade = 1;
  BehaviorSubject<int> _controllerQuantidade = new BehaviorSubject<int>();

  Stream<int> get outQuantidade => _controllerQuantidade.stream;

  Sink<int> get inQuantidade => _controllerQuantidade.sink;

  Fetch(kg) {
    if (kg) {
      _controllerQuantidade.add(1000);
    } else {
      _controllerQuantidade.add(quantidade);
    }
  }

  @override
  void dispose() {
    _controllerQuantidade.close();
  }
}
