import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class AnunciantesController extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  List usuarios;
  List<User> anunciantes;
  BehaviorSubject<List<User>> anunciantesController =
      BehaviorSubject<List<User>>();
  Stream<List<User>> get outAnunciantes => anunciantesController.stream;
  Sink<List<User>> get inAnunciantes => anunciantesController.sink;
  AnunciantesController(this.usuarios) {
    Start();
  }
  Start() async {
    anunciantes = new List();
    if(usuarios != null) {
      for (String u in usuarios) {
        User user = User.fromJson((await userRef.document(u).get()).data);
        anunciantes.add(user);
      }
    }
    inAnunciantes.add(anunciantes);
  }
}
