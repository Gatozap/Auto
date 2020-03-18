import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:rxdart/rxdart.dart';

class PersonagensController extends BlocBase {
  BehaviorSubject<List<Personagem>> personagensController =
      BehaviorSubject<List<Personagem>>();
  Stream<List<Personagem>> get outPersonagens => personagensController.stream;
  Sink<List<Personagem>> get inPersonagens => personagensController.sink;
  List<Personagem> Personagens;
  List<Personagem> Personagensmain;


  BehaviorSubject<Personagem> personagenSelecionadoController =
  BehaviorSubject<Personagem>();
  Stream<Personagem> get outPersonagenSelecionado => personagenSelecionadoController.stream;
  Sink<Personagem> get inPersonagenSelecionado => personagenSelecionadoController.sink;
  Personagem personagemSelecionado;

  PersonagensController({aventura,Personagem personagem}) {
    personagemSelecionado = personagem;
    inPersonagenSelecionado.add(personagemSelecionado);
    personagensRef
        .where("user", isEqualTo: Helper.localUser.id)
        .snapshots()
        .listen((QuerySnapshot snap) {
        Personagens = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {
          print('AQUI DS ${ds.data}');
          Personagem p = Personagem.fromJson(ds.data);
          p.id = ds.documentID;
          Personagens.add(p);
        }
        Personagens.sort(
            (Personagem a, Personagem b) => a.nome.compareTo(b.nome));
        Personagensmain = Personagens;
        inPersonagens.add(Personagens);
      } else {
        inPersonagens.add(Personagens);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }

  PersonagensNomeFiltro(String nome) {
    List<Personagem> personagensFiltrados = new List();
    for (Personagem p in Personagensmain) {
      if (p.nome == Personagensmain) {
        personagensFiltrados.add(p);
      }
      Personagens = personagensFiltrados;
      inPersonagens.add(Personagens);
    }
  }

  @override
  void dispose() {
    personagensController.close();
  }
}
