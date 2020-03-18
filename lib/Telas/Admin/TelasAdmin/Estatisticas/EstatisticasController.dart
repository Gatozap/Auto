import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:rxdart/rxdart.dart';

class EstatisticaController extends BlocBase{
  BehaviorSubject<List<Corrida>> corridasController = BehaviorSubject<List<Corrida>>();
  Stream<List<Corrida>> get outCorridas => corridasController.stream;
  Sink<List<Corrida>> get inCorridas => corridasController.sink;
  List<Corrida> corridas;

  BehaviorSubject<double> visualizacoesController = BehaviorSubject<double>();
  Stream<double> get outVisualizacoes => visualizacoesController.stream;
  Sink<double> get inVisualizacoes => visualizacoesController.sink;
  double visualizacoes;


  EstatisticaController(Campanha campanha, Carro carro, User user){
    if(user == null){
    if(carro == null) {
      if (campanha == null) {
        corridasRef
            .getDocuments()
            .then((v) {
          corridas = new List();

          for (var i in v.documents) {
            print('aqui corrida ${corridas.length} ');
            Corrida p = Corrida.fromJsonFirestore(i.data);
            p.id = i.documentID;

            corridas.add(p);
          }

          corridas.sort(
                  (Corrida a, Corrida b) => b.id.compareTo(a.id));
          inCorridas.add(corridas);
        });
      } else {
        corridasRef.where('campanha', isEqualTo: campanha.id)
            .getDocuments()
            .then((v) {
          corridas = new List();

          for (var i in v.documents) {
            print('aqui corrida ${corridas.length} ');
            Corrida p = Corrida.fromJsonFirestore(i.data);
            p.id = i.documentID;

            corridas.add(p);
          }

          corridas.sort(
                  (Corrida a, Corrida b) => b.id.compareTo(a.id));
          inCorridas.add(corridas);
        });
      }
    }else{
      corridasRef.where('carro.id', isEqualTo: carro.id)
          .getDocuments()
          .then((v) {
        corridas = new List();

        for (var i in v.documents) {
          print('aqui corrida ${corridas.length} ');
          Corrida p = Corrida.fromJsonFirestore(i.data);
          p.id = i.documentID;

          corridas.add(p);
        }

        corridas.sort(
                (Corrida a, Corrida b) => b.id.compareTo(a.id));
        inCorridas.add(corridas);
      });
    }}else{
      corridasRef.where('user', isEqualTo: user.id)
          .getDocuments()
          .then((v) {
        corridas = new List();

        for (var i in v.documents) {
          print('aqui corrida ${corridas.length} ');
          Corrida p = Corrida.fromJsonFirestore(i.data);
          p.id = i.documentID;

          corridas.add(p);
        }

        corridas.sort(
                (Corrida a, Corrida b) => b.id.compareTo(a.id));
        inCorridas.add(corridas);
      });
    }
  }


  @override
  void dispose() {
    corridasController.close();
       visualizacoesController.close();
  }

}