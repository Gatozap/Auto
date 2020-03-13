import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Localizacao.dart';
import 'package:bocaboca/Telas/Card/bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:rxdart/rxdart.dart';

class EstatisticasController extends BlocBase{
  BehaviorSubject<List<Corrida>> corridasController = BehaviorSubject<List<Corrida>>();
  Stream<List<Corrida>> get outCorridas => corridasController.stream;
  Sink<List<Corrida>> get inCorridas => corridasController.sink;
  List<Corrida> corridas;



  EstatisticasController(){
    corridasRef
        .getDocuments()
        .then((v) {
      corridas = new List();

      for (var i in v.documents) {
        Corrida p = Corrida.fromJsonFirestore(i.data);
        p.id = i.documentID;
        
        corridas.add(p);
      }
      print('aqui corrida ${corridas.length} ');
      corridas.sort(
              (Corrida a, Corrida b) => b.id.compareTo(a.id) );
      inCorridas.add(corridas);
    }).catchError((err){
      print('erro 1 ${err.toString()}');
    });
  }


  @override
  void dispose() {
    corridasController.close();

  }

}