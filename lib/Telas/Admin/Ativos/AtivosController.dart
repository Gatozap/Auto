import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Ativo.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class AtivosController extends BlocBase {
  BehaviorSubject<List<Ativo>> ativosController =
      BehaviorSubject<List<Ativo>>();
  Stream<List<Ativo>> get outAtivos => ativosController.stream;
  Sink<List<Ativo>> get inAtivos => ativosController.sink;
  Map<String, DatabaseReference> corridasRef;

  BehaviorSubject<Map> localizacoesController = BehaviorSubject<Map>();
  Stream<Map> get outLocalizacoes => localizacoesController.stream;
  Sink<Map> get inLocalozacoes => localizacoesController.sink;
  List<Ativo> ativos;
  AtivosController() {
    ativosRef.where('isActive', isEqualTo: true).getDocuments().then((v) {
      ativos = new List();
      corridasRef = new Map<String, DatabaseReference>();
      for (var d in v.documents) {
        ativos.add(Ativo.fromJson(d.data));
      }
      inAtivos.add(ativos);
      for (Ativo a in ativos) {
        corridasRef[a.id_corrida] = FirebaseDatabase.instance
            .reference()
            .child('Corridas')
            .reference()
            .child(a.id_corrida)
            .child('points');
      }
      PegarLocalizacoes();
    });
  }

  @override
  void dispose() {
    ativosController.close();
  }

  Map localizacoes;
  void PegarLocalizacoes() {
    if (localizacoes == null) {
      localizacoes = Map();
    }
    corridasRef.forEach((k, dr) {
      List positions = new List();
      dr.onValue.listen((points) {
        positions = new List();
        if (points.snapshot.value.toString() != 'null') {
          var pts = points.snapshot.value;
          pts.forEach((k, v) {
            positions.add(v);
          });
          positions.sort((var a, var b) {
            return a['timestamp'].compareTo(b['timestamp']);
          });
        }
        try {
          localizacoes[k] = positions.last != null ? positions.last : null;
        }catch(err){
          print('Error $err');
        }
        inLocalozacoes.add(localizacoes);
      });
    });
  }
}
