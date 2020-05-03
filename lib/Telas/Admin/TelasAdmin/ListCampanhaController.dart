
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ListaCampanhaController extends BlocBase {

  BehaviorSubject<List<Campanha>> campanhasController = BehaviorSubject<List<Campanha>>();
  Stream<List<Campanha>> get outCampanhas => campanhasController.stream;
  Sink<List<Campanha>> get inCampanhas => campanhasController.sink;
  List<Campanha> campanhas;
  List<Campanha> campanhasmain;

  Campanha c;
  User u;

  BehaviorSubject<Campanha> campanhaSelecionadoController =
  BehaviorSubject<Campanha>();
  Stream<Campanha> get outCampanhaSelecionado => campanhaSelecionadoController.stream;
  Sink<Campanha> get inCampanhaSelecionado => campanhaSelecionadoController.sink;
  Campanha campanhaSelecionado;


  ListaCampanhaController({Campanha campanha}) {
    campanhaSelecionado = campanha;
    inCampanhaSelecionado.add(campanhaSelecionado);
    campanhasRef
         .where('id')
        .snapshots()
        .listen((QuerySnapshot snap) {
      campanhas = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {

          Campanha p = Campanha.fromJson(ds.data);
          p.id = ds.documentID;
          campanhas.add(p);
        }
        campanhas.sort(
                (Campanha a, Campanha b) => b.id.compareTo(a.id));
        campanhasmain = campanhas;
        inCampanhas.add(campanhas);
      } else {
        inCampanhas.add(campanhas);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }


  @override
  void dispose() {
    campanhasController.close();
    campanhaSelecionadoController.close();

    // TODO: implement dispose
  }
}