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
  BehaviorSubject<List<Carro>> carrosController =
      BehaviorSubject<List<Carro>>();
  Stream<List<Carro>> get outCarros => carrosController.stream;
  Sink<List<Carro>> get inCarros => carrosController.sink;
  List<Carro> carros;
  List<Carro> carrosmain;

  BehaviorSubject<List<User>> usersController = BehaviorSubject<List<User>>();
  Stream<List<User>> get outUsers => usersController.stream;
  Sink<List<User>> get inUsers => usersController.sink;
  List<User> users;
  List<User> usersmain;

  Carro c;
  User u;

  List horarios = [
    {'manha': false},
    {'tarde': false},
    {'noite': false}
  ];

  BehaviorSubject<List> horariosController = BehaviorSubject();
  Stream<List> get outHorarios => horariosController.stream;
  Sink<List> get inHorarios => horariosController.sink;

  BehaviorSubject<Carro> carroSelecionadoController = BehaviorSubject<Carro>();
  Stream<Carro> get outCarroSelecionado => carroSelecionadoController.stream;
  Sink<Carro> get inCarroSelecionado => carroSelecionadoController.sink;
  Carro carroSelecionado;

  BehaviorSubject<String> _controllerSearchText = new BehaviorSubject<String>();
  Stream<String> get outSearchText => _controllerSearchText.stream;
  Sink<String> get inSearchText => _controllerSearchText.sink;

  ListaCarroController({Carro carro, Campanha campanha}) {
    if (listc == null) {
      listc = new ListaCampanhaController();
    }
    inHorarios.add(horarios);
    carroSelecionado = carro;
    inCarroSelecionado.add(carroSelecionado);
    carrosRef
        .where("campanhas", arrayContains: listc.campanhas)
        .snapshots()
        .listen((QuerySnapshot snap) {
      carros = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {
          Carro p = Carro.fromJson(ds.data);
          p.id = ds.documentID;
          carros.add(p);
        }
        carros.sort((Carro a, Carro b) => a.placa.compareTo(b.placa));
        carrosmain = carros;
        inCarros.add(carros);
      } else {
        inCarros.add(carros);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

    userRef.snapshots().listen((QuerySnapshot snap) {
      users = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {
          User p = User.fromJson(ds.data);
          p.id = ds.documentID;
          users.add(p);
        }
        users.sort((User a, User b) => a.id.compareTo(b.id));
        usersmain = users;
        inUsers.add(users);
      } else {
        inUsers.add(users);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }

  @override
  void dispose() {
    carrosController.close();
    carroSelecionadoController.close();
    horariosController.close();
    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {
    List<Carro> carrosFiltrados = new List();
    if (selectedCategoria == 'Nenhuma') {
      carrosFiltrados = carrosmain;
      carros = carrosFiltrados;
      inCarros.add(carros);
      return;
    }
    for (Carro c in carrosmain) {
      if (selectedCategoria == 'lateral') {
        if (c.is_anuncio_laterais) {
          carrosFiltrados.add(c);
        }
      }
      if (selectedCategoria == 'banco') {
        if (c.is_anuncio_bancos) {
          carrosFiltrados.add(c);
        }
      }
      if (selectedCategoria == 'traseira') {
        if (c.is_anuncio_traseira_completa) {
          carrosFiltrados.add(c);
        }
      }
      if (selectedCategoria == 'vidro_traseiro') {
        if (c.is_anuncio_vidro_traseiro) {
          carrosFiltrados.add(c);
        }
      }
    }
    carros = carrosFiltrados;
    inCarros.add(carros);
    return;
  }

  void FilterByHorarios() {
    List<Carro> carrosFiltrados = new List();
    if (!horarios[0]['manha'] &&
        !horarios[1]['tarde'] &&
        horarios[2]['noite']) {
      carrosFiltrados = carrosmain;
      carros = carrosFiltrados;
      inCarros.add(carros);
      return;
    }
    for (Carro c in carrosmain) {
      bool manha = false;
      bool tarde = false;
      bool noite = false;
      if (horarios[0]['manha']) {
        for (User u in users) {
          if (u.id == c.dono) {
            if (u.manha) {
              manha = true;
            }
          }
        }
      }
      if (horarios[1]['tarde']) {
        for (User u in users) {
          if (u.id == c.dono) {
            if (u.manha) {
              tarde = true;
            }
          }
        }
      }
      if (horarios[2]['noite']) {
        for (User u in users) {
          if (u.id == c.dono) {
            if (u.manha) {
              noite = true;
            }
          }
        }
      }

      if (horarios[2]['noite'] == noite &&
          horarios[1]['tarde'] == tarde &&
          horarios[0]['manha'] == manha) {
        carrosFiltrados.add(c);
      }
    }

    carros = carrosFiltrados;
    inCarros.add(carros);
    return;
  }

  void FilterByCidade(s) {
    List<Carro> carrosFiltrados = new List();
    if (s == 'Todos') {
      carrosFiltrados = carrosmain;
      carros = carrosFiltrados;
      inCarros.add(carros);
      return;
    }
    for (Carro c in carrosmain) {
      for (User u in users) {
        if (u.id == c.dono) {
          if (u.endereco != null) {
            if (s == u.endereco.cidade) {
              carrosFiltrados.add(c);
            }
          }
        }
      }
    }
    carros = carrosFiltrados;
    inCarros.add(carros);
    return;
  }


  void FilterByNome(String s) {
    List<Carro> userFiltrados = new List();
    if(s == '0'|| s=='') {
      userFiltrados = carrosmain;
      carros = userFiltrados;
      inCarros.add(carros);
    }else{
      for(Carro c in carrosmain) {
        if(c.toString().contains(s)){
          userFiltrados.add(c);
        }
      }
      carros = userFiltrados;
      inCarros.add(carros);
    }

  }
}
