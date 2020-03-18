import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Objetos/Talento.dart';
import 'package:rxdart/rxdart.dart';

class TalentoController extends BlocBase {
  BehaviorSubject<List<Talento>> talentosController =
      BehaviorSubject<List<Talento>>();
  Sink<List<Talento>> get inTalentos => talentosController.sink;
  Stream<List<Talento>> get outTalentos => talentosController.stream;
  List<Talento> talentos;
  List<Talento> talentosMain;

  TalentoController({aventura}) {
    talentosRef.snapshots().listen((QuerySnapshot snap) {
      if (talentos == null) {
        talentos = new List();
      }
      for (DocumentSnapshot ds in snap.documents) {
        Talento t = Talento.fromJson(ds.data);
        t.id = ds.documentID;
        talentos.add(t);
      }
      talentosMain = talentos;
      inTalentos.add(talentos);
    });
  }

  FiltrarTalentoPorNome(String desc) {
    List<Talento> talentosFiltrados = new List();
    for (Talento t in talentosMain) {
      if (t.nome.toLowerCase().contains(desc.toLowerCase())) {
        talentosFiltrados.add(t);
      }
    }
    talentos = talentosFiltrados;
    inTalentos.add(talentos);
  }

  List<Talento> getSuggestions(String pattern, Personagem personagem) {
    List<Talento> talentosFiltrados = new List();
    for (Talento t in talentosMain) {
      if (t.nome.toLowerCase().contains(pattern.toLowerCase())) {
        if (personagem.talentos != null) {
          bool contains = false;
          for (Talento talentoPersonagem in personagem.talentos) {
            if (talentoPersonagem.nome == t.nome) {
              contains = true;
            }
          }
          if (!contains) {
            talentosFiltrados.add(t);
          }
        } else {
          talentosFiltrados.add(t);
        }
      }
    }
    return talentosFiltrados;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
