import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class SolicitacoesListController extends BlocBase {
  BehaviorSubject<List<Solicitacao>> controllerSolicitacoes =
      BehaviorSubject<List<Solicitacao>>();
  Stream<List<Solicitacao>> get outSolicitacoes =>
      controllerSolicitacoes.stream;
  Sink<List<Solicitacao>> get inSolicitacoes => controllerSolicitacoes.sink;
  List<Solicitacao> solicitacoes;

  SolicitacoesListController({user, campanha}) {
    solicitacoes = new List();
    if (user == null) {
      if (campanha == null) {
        solicitacoesRef.getDocuments().then((v) {
          for (var d in v.documents) {
            solicitacoes.add(Solicitacao.fromJson(d.data));
          }
          inSolicitacoes.add(solicitacoes);
        });
      } else {
        solicitacoesRef
            .where('campanha', isEqualTo: campanha)
            .getDocuments()
            .then((v) {
          for (var d in v.documents) {
            solicitacoes.add(Solicitacao.fromJson(d.data));
          }
          inSolicitacoes.add(solicitacoes);
        });
      }
    } else {
      solicitacoesRef.where('user', isEqualTo: user).getDocuments().then((v) {
        for (var d in v.documents) {
          solicitacoes.add(Solicitacao.fromJson(d.data));
        }
        inSolicitacoes.add(solicitacoes);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
