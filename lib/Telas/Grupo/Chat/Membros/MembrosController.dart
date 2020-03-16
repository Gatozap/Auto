import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

class MembrosController extends BlocBase {
  BehaviorSubject<List<User>> controlleUsers =
      new BehaviorSubject<List<User>>();
  List<User> users;
  Stream<List<User>> get outUsers => controlleUsers.stream;

  Sink<List<User>> get inUsers => controlleUsers.sink;

  BehaviorSubject<List<User>> controllerParticipantes =
  new BehaviorSubject<List<User>>();
  List<User> participantes;
  Stream<List<User>> get outParticipantes => controllerParticipantes.stream;

  Sink<List<User>> get inParticipantes => controllerParticipantes.sink;
  Sala s;

  MembrosController(Sala s) {
    users = new List();
    s.meta.forEach((k, j) {
      userRef.document(k).get().then((v) {
        User u = User.fromJson(v);
        if (!users.contains(u)) {
          print('AQUI V ${j}');
          u.isGroupAdm = j['isAdm'] == null ? false : j['isAdm'];
          users.add((u));
        }
        inUsers.add(users);
      });
    });
    participantes = new List();
    if(s.pedidos != null) {
      for (String a in s.pedidos) {
        inParticipantes.add(participantes);
        userRef.document(a).get().then((v) {
          User u = User.fromJson(v);
          if (!participantes.contains(u)) {
            print('AQUI V ${u}');
            u.isGroupAdm = false;
            participantes.add((u));
          }
          inParticipantes.add(participantes);
        });
      }
    }
  }

  removerParticipante(Sala s, String user){
    List pedidos = List();
    for(String a in s.pedidos){
      if(a != user){
        pedidos.add(a);
      }
    }
    s.pedidos = pedidos;
    chatRef.document(s.id).setData(s.toJson()).then((v){
      participantes = new List();
      if(s.pedidos != null) {
        inParticipantes.add(participantes);
        for (String a in s.pedidos) {
          userRef.document(a).get().then((v) {
            User u = User.fromJson(v);
            if (!participantes.contains(u)) {
              print('AQUI V ${u}');
              u.isGroupAdm = false;
              participantes.add((u));
            }
            inParticipantes.add(participantes);
          });
        }
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controlleUsers.close();
  }
}
