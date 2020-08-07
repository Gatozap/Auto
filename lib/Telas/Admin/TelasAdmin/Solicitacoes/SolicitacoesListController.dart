import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class SolicitacoesListController extends BlocBase {
  BehaviorSubject<List<Solicitacao>> controllerSolicitacoes =
      BehaviorSubject<List<Solicitacao>>();
  Stream<List<Solicitacao>> get outSolicitacoes =>
      controllerSolicitacoes.stream;
  Sink<List<Solicitacao>> get inSolicitacoes => controllerSolicitacoes.sink;
  List<Solicitacao> solicitacoes;

  SolicitacoesListController({user, campanha}) {

    if (user == null) {
      if (campanha == null) {
        solicitacoesRef.where('isAprovado',isNull: true).snapshots().listen((v) {
          solicitacoes = new List();
          for (var d in v.documents) {
            solicitacoes.add(Solicitacao.fromJson(d.data));
          }
          solicitacoes.sort((Solicitacao a, Solicitacao b,)=>b.created_at.compareTo(a.created_at));
          inSolicitacoes.add(solicitacoes);
        });
      } else {
        solicitacoesRef
            .where('campanha', isEqualTo: campanha.id)
            .snapshots().listen((v) {
          solicitacoes = new List();
          for (var d in v.documents) {
            solicitacoes.add(Solicitacao.fromJson(d.data));
          }
          solicitacoes.sort((Solicitacao a, Solicitacao b,)=>b.created_at.compareTo(a.created_at));
          inSolicitacoes.add(solicitacoes);
        });
      }
    } else {
      solicitacoesRef.where('usuario', isEqualTo: user.id).snapshots().listen((v) {
        solicitacoes = new List();
        for (var d in v.documents) {
          solicitacoes.add(Solicitacao.fromJson(d.data));
        }
        solicitacoes.sort((Solicitacao a, Solicitacao b,)=>b.created_at.compareTo(a.created_at));
        inSolicitacoes.add(solicitacoes);
      });
    }
  }

  @override
  void dispose() {
    controllerSolicitacoes.close();
  }
}
