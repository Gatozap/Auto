import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class AddEstoqueController implements BlocBase {
  int disponivel = 1;
  BehaviorSubject<int> _controllerDisponivel = new BehaviorSubject<int>();

  Stream<int> get outDisponivel => _controllerDisponivel.stream;

  Sink<int> get inDisponivel => _controllerDisponivel.sink;

  int minimo = 1;
  BehaviorSubject<int> _controllerMinimo = new BehaviorSubject<int>();

  Stream<int> get outMinimo => _controllerMinimo.stream;

  Sink<int> get inMinimo => _controllerMinimo.sink;
  Fetch(kg) {
    if (kg) {
      _controllerDisponivel.add(1000);
    } else {
      _controllerDisponivel.add(disponivel);
    }
    if (kg) {
      _controllerMinimo.add(minimo);
    } else {
      _controllerMinimo.add(minimo);
    }
  }

  @override
  void dispose() {
    _controllerDisponivel.close();
    _controllerMinimo.close();
  }
}
