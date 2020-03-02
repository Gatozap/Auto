import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Campanha.dart';

import 'package:rxdart/rxdart.dart';

class CampanhaController extends BlocBase {
  BehaviorSubject<Campanha> _controllerCampanha = new BehaviorSubject<Campanha>();
  Stream<Campanha> get outCampanha => _controllerCampanha.stream;
  Sink<Campanha> get inCampanha => _controllerCampanha.sink;
  Campanha campanha;

  CampanhaController({this.campanha});


 Future CriarCampanha({Campanha campanha}){
        return campanhasRef.add(campanha.toJson()).then((v){
          campanha.id = v.documentID;

          campanhasRef.document(campanha.id).updateData(campanha.toJson()).then((v){
            dToast('Campanha cadastrada com sucesso');

          }).catchError((err) {
            print('aqui erro 1 ${err}');
            return null;
          });
        }).catchError((err) {
          print('aqui erro 2 ${err}');
          return null;
        });
 }

  @override
  void dispose() {
    _controllerCampanha.close();
    // TODO: implement dispose
  }

}