import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Agendamento.dart';
import 'package:autooh/Objetos/Instalacao.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class AgendamentoListController extends BlocBase {
  List<Instalacao> instalacoes;
  BehaviorSubject<List<Instalacao>> controllerInstalacoes =
      BehaviorSubject<List<Instalacao>>();
  Stream<List<Instalacao>> get outInstalacoes => controllerInstalacoes.stream;
  Sink<List<Instalacao>> get inInstalacoes => controllerInstalacoes.sink;
  Parceiro parceiro;
  AgendamentoListController({this.parceiro}) {
    if (parceiro == null) {
      instalacoesRef
          .where('hora_agendada',
              isGreaterThan: DateTime.now()
                  .subtract(Duration(hours: 12))
                  .millisecondsSinceEpoch)
          .getDocuments()
          .then((v) {
        instalacoes = new List();
        for (var d in v.documents) {
          instalacoes.add(Instalacao.fromJson(d.data));
        }
        instalacoes.sort((Instalacao a, Instalacao b) =>
            a.hora_agendada.compareTo(b.hora_agendada));
        inInstalacoes.add(instalacoes);
      });
    } else {
      instalacoesRef
          .where('parceiro_query', isEqualTo: parceiro.id)
          .where('hora_agendada',
              isGreaterThan: DateTime.now()
                  .subtract(Duration(hours: 12))
                  .millisecondsSinceEpoch)
          .getDocuments()
          .then((v) {
        instalacoes = new List();
        for (var d in v.documents) {
          instalacoes.add(Instalacao.fromJson(d.data));
        }
        instalacoes.sort((Instalacao a, Instalacao b) =>
            a.hora_agendada.compareTo(b.hora_agendada));
        inInstalacoes.add(instalacoes);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
