import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helpers.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:rxdart/rxdart.dart';
import 'package:autooh/Objetos/User.dart';

class ChatListController extends BlocBase {
  BehaviorSubject<List<Sala>> salasController =
      new BehaviorSubject<List<Sala>>();
  Stream<List<Sala>> get outSalas => salasController.stream;
  Sink<List<Sala>> get inSalas => salasController.sink;
  List<Sala> salas;
     User user;
  ChatListController() {
    if (salas == null) {
      salas = new List();
    }

    chatRef
        .where('membros', arrayContains: 'suporte')
        .snapshots()
        .listen((v) {
      salas = new List();
      for (var j in v.documents) {
        Sala s = new Sala.fromJson(j.data);
        s.id = j.documentID;
        if (s.lastMessage != null) {
          salas.add(s);
        }
      }
      salas.sort((a, b) => b.updated_at.compareTo(a.updated_at));
      inSalas.add(salas);
    }).onError((err) {
      print('Error:${err.toString()}');
      inSalas.add(salas);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    salasController.close();
  }
}
