
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'ListCampanhaController.dart';

class ListaCarroController extends BlocBase {
  ListaCampanhaController listc;
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


  ListaCarroController({Carro carro, Campanha campanha}) {
    if(listc == null){
      listc = new ListaCampanhaController();
    }
    carroSelecionado = carro;
    inCarroSelecionado.add(carroSelecionado);
    carrosRef
        .where("campanhas", arrayContains:  listc.campanhas)
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


  @override
  void dispose() {
    carrosController.close();
    carroSelecionadoController.close();

    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {
    List<Carro> carrosFiltrados = new List();
    if(selectedCategoria == 'Nenhuma'){
      carrosFiltrados = carrosmain;
      carros = carrosFiltrados;
      inCarros.add(carros);
      return;
    }
    for(Carro c in carrosmain){
      if(selectedCategoria == 'lateral'){
        if(c.is_anuncio_laterais){
          carrosFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'banco'){
        if(c.is_anuncio_bancos){
          carrosFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'traseira'){
        if(c.is_anuncio_traseira_completa){
          carrosFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'vidro_traseiro'){
        if(c.is_anuncio_vidro_traseiro){
          carrosFiltrados.add(c);
        }
      }
    }
    carros = carrosFiltrados;
    inCarros.add(carros);
    return;
  }
}