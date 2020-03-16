import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autooh/Objetos/News.dart';
import 'package:rxdart/rxdart.dart';

import 'Helper.dart';

class NewsController implements BlocBase {
  BehaviorSubject<String> _controllerNews = new BehaviorSubject<String>();

  StreamSubscription<String> controllerNews;
  DatabaseReference _newsRef = FirebaseDatabase.instance
      .reference()
      .child(Helper.localUser.id.toString())
      .child('News');
  Stream<String> get outNews => _controllerNews.stream;

  Sink<String> get inNews => _controllerNews.sink;
  @override
  void dispose() {
    _controllerNews.close();
  }

  NewsController() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    database
        .reference()
        .child(Helper.localUser.id.toString())
        .child('News')
        .once()
        .then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  Future<Null> increment(News n) async {
    _newsRef.push().set(n.toMap()).then((d) {
      print('Foi');
    });
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  /*Future<void> openNews(News n, context) {
    print(n.toString());
    switch (n.tipo) {
      case 0:
        //print('Entrou aqui case 0');
        print(
            ' http://www.aproximamais.net/webservice/json.php?buscaprotocoloid=' +
                n.sujeito);
        // BEHAIVIOUR PRA ABRIR PROTOCOLO
        http
            .get(
                'http://www.aproximamais.net/webservice/json.php?buscaprotocoloid=' +
                    n.sujeito)
            .then((response) {
          print('RESPONSE AQUI: ${json.decode(response.body)}');
          var j = json.decode(response.body);
          Protocolo p;
          for (var v in j) {
            print(v.toString());
            p = new Protocolo.fromJson(v);
          }
          print(p.toString());
          if (p != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComentarioPage(p),
                ));
          }
        }).catchError((err) {
          print('error: ${err.toString()}');
        });
    }
  }*/
}
