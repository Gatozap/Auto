import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:rxdart/rxdart.dart';

class ChatListController extends BlocBase {
  BehaviorSubject<List<Sala>> salasController =
      new BehaviorSubject<List<Sala>>();
  Stream<List<Sala>> get outSalas => salasController.stream;
  Sink<List<Sala>> get inSalas => salasController.sink;
  List<Sala> salas;

  ChatListController() {
    if (salas == null) {
      salas = new List();
    }
    chatRef
        .where('membros', arrayContains: Helper.localUser.id)
        .snapshots()
        .listen((v) {
      salas = new List();
      for (var j in v.documents) {
        Sala s = new Sala.fromJson(j.data);
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
