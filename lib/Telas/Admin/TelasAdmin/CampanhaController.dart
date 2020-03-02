import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Objetos/Campanha.dart';

import 'package:rxdart/rxdart.dart';

class CampanhaController extends BlocBase {
  BehaviorSubject<Campanha> _controllerCampanha = new BehaviorSubject<Campanha>();
  Stream<Campanha> get outCampanha => _controllerCampanha.stream;
  Sink<Campanha> get inCampanha => _controllerCampanha.sink;
  Campanha campanha;

  CampanhaController({this.campanha});




  @override
  void dispose() {
    _controllerCampanha.close();
    // TODO: implement dispose
  }

}