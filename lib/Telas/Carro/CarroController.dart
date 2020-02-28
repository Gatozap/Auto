import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class CarroController extends BlocBase {
  BehaviorSubject<Carro> carroController = new BehaviorSubject<Carro>();

  Stream<Carro> get outCarro => carroController.stream;

  Sink<Carro> get inCarro => carroController.sink;

  BehaviorSubject<User> userController = new BehaviorSubject<User>();

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;


  BehaviorSubject<List<Carro>> carrosController = BehaviorSubject<List<Carro>>();
  Stream<List<Carro>> get outCarros => carrosController.stream;
  Sink<List<Carro>> get inCarros => carrosController.sink;
  List<Carro> carros;
  List<Carro> carrosmain;

  Carro c;
  User u;

  BehaviorSubject<Carro> carroSelecionadoController =
  BehaviorSubject<Carro>();
  Stream<Carro> get outCarroSelecionado => carroSelecionadoController.stream;
  Sink<Carro> get inCarroSelecionado => carroSelecionadoController.sink;
  Carro carroSelecionado;


  CarroController({Carro carro}) {
    carroSelecionado = carro;
    inCarroSelecionado.add(carroSelecionado);
    carrosRef
        .where("dono", isEqualTo: Helper.localUser.id)
        .snapshots()
        .listen((QuerySnapshot snap) {
      carros = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {

          Carro p = Carro.fromJson(ds.data);
          p.id = ds.documentID;
          carros.add(p);
        }
        carros.sort(
                (Carro a, Carro b) => a.placa.compareTo(b.placa));
        carrosmain = carros;
        inCarros.add(carros);
      } else {
        inCarros.add(carros);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }


  Future<String> updateCarro(Carro carro) async {



    if (carro != null) {
      return carrosRef.document(carro.id).updateData(carro.toJson()).then((v) {
        inCarro.add(carro);

     

          return userRef
              .document(Helper.localUser.id)
              .updateData(Helper.localUser.toJson())
              .then((v) {
            
            dToast('Item Atualizado com sucesso!');
    
          });

        return 'Atualizado com sucesso!';
      }).catchError((err) {
        print('Error: ${err}');
        return 'Error: ${err}';
      });
    } else {
      return Future.delayed(Duration(seconds: 1)).then((v) {
        return 'Erro: Carro Nulo';
      });
    }
  }

  @override
  void dispose() {
    carroController.close();
    userController.close();
    carrosController.close();
    // TODO: implement dispose
  }
}
