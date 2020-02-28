import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Pacote.dart';
import 'package:rxdart/subjects.dart';

class PacoteListController extends BlocBase {
  List<Pacote> pacotes;
  BehaviorSubject<List<Pacote>> pacotesController =
      BehaviorSubject<List<Pacote>>();
  Stream<List<Pacote>> get outPacotes => pacotesController.stream;
  Sink<List<Pacote>> get inPacotes => pacotesController.sink;

  PacoteListController() {
    if (pacotes == null) {
      pacotes = new List();
      inPacotes.add(pacotes);
    }
    pacotesRef
        .where('prestador', isEqualTo: Helper.localUser.prestador)
        .snapshots()
        .listen((snap) {
      if (snap.documents.length != 0) {
        if (pacotes == null) {
          pacotes = new List();
        }
        for (var j in snap.documents) {
          Pacote p = new Pacote.fromJson(j.data);
          p.id = j.documentID;
          pacotes.add(p);
        }

        pacotes.sort((Pacote a, Pacote b) => b.created_at.millisecondsSinceEpoch
            .compareTo(a.created_at.millisecondsSinceEpoch));
        inPacotes.add(pacotes);
      }
    }).onError((err) {
      print('Error :${err.toString()}');
    });
  }

  @override
  void dispose() {
    pacotesController.close();
    // TODO: implement dispose
  }
}
