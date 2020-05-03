import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Instalacao.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AgendamentoController extends BlocBase {
  BehaviorSubject<List<Instalacao>> controllerInstalacao =
  BehaviorSubject<List<Instalacao>>();
  Stream<List<Instalacao>> get outInstalacao =>
      controllerInstalacao.stream;
  Sink<List<Instalacao>> get inInstalacao => controllerInstalacao.sink;
  List<Instalacao> instalacoes;
   List<Instalacao> instalacoesmain;

  BehaviorSubject<Instalacao> controllerSelecionadoInstalacao =
  BehaviorSubject<Instalacao>();
  Stream<Instalacao> get outInstalacaoSelecionado => controllerSelecionadoInstalacao.stream;
  Sink<Instalacao> get inInstalacaoSelecionado => controllerSelecionadoInstalacao.sink;
  Instalacao instalacaoSelecionado;


  AgendamentoController({instalacao}) {
    instalacaoSelecionado = instalacao;
    inInstalacaoSelecionado.add(instalacaoSelecionado);
    campanhasRef
        .where('id')
        .snapshots()
        .listen((QuerySnapshot snap) {
      instalacoes = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {

          Instalacao p = Instalacao.fromJson(ds.data);
          p.id = ds.documentID;
          instalacoes.add(p);
        }
        instalacoes.sort(
                (Instalacao a, Instalacao b) => b.id.compareTo(a.id));
        instalacoesmain = instalacoes;
        inInstalacao.add(instalacoes);
      } else {
        inInstalacao.add(instalacoes);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }

  @override
  void dispose() {
    controllerInstalacao.close();
    controllerSelecionadoInstalacao.close();
  }
}
