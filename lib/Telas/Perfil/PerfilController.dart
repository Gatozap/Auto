import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rxdart/rxdart.dart';

class PerfilController extends BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();
  BehaviorSubject<String> _controllerSearchText = new BehaviorSubject<String>();
  Stream<String> get outSearchText => _controllerSearchText.stream;
  Sink<String> get inSearchText => _controllerSearchText.sink;

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;
  User u;

  BehaviorSubject<List<User>> usersController = BehaviorSubject<List<User>>();
  Stream<List<User>> get outUsers => usersController.stream;
  Sink<List<User>> get inUsers => usersController.sink;
  List<User> users;
  List<User> usersmain;




  BehaviorSubject<User> userSelecionadoController =
  BehaviorSubject<User>();
  Stream<User> get outUserSelecionado => userSelecionadoController.stream;
  Sink<User> get inUserSelecionado => userSelecionadoController.sink;
  User userSelecionado;


  PerfilController(User user) {
    u = user;
    if(Helper.localUser.data_nascimento != null) {
      Helper.localUser.data_nascimento =
          Helper.localUser.data_nascimento.add(Duration(hours: 3));
    }else{
      Helper.localUser.data_nascimento = DateTime.now();
    }
    if (u != null) {
      if(u.data_nascimento != null) {
        u.data_nascimento = u.data_nascimento.add(Duration(hours: 3));
        print("data de nascimento AQUI ${u.data_nascimento.toIso8601String()}");
      }else{
        u.data_nascimento = DateTime.now();
      }
      inUser.add(u);
      userRef.document(u.id).snapshots().listen((snap) {
        u = new User.fromJson(snap.data);

        u.data_nascimento = u.data_nascimento.add(Duration(hours: 3));
        print("data de nascimento AQUI ${u.data_nascimento.toIso8601String()}");
        inUser.add(u);
      });
    }
    userSelecionado = user;
    inUserSelecionado.add(userSelecionado);
    userRef
        .where("id")
        .snapshots()
        .listen((QuerySnapshot snap) {
      users = new List();

      if (snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {

          User p = User.fromJson(ds.data);
          p.id = ds.documentID;
          users.add(p);
        }
        users.sort(
                (User a, User b) => a.id.compareTo(b.id));
        usersmain = users;
        inUsers.add(users);
      } else {
        inUsers.add(users);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

  }
  void FilterByCategoria(String selectedCategoria) {
    List<User> userFiltrados = new List();
    if(selectedCategoria == 'Nenhuma'){
      userFiltrados = usersmain;
      users = userFiltrados;
      inUsers.add(users);
      return;
    }
    for(User c in usersmain){
      if(selectedCategoria == 'manha'){
        if(c.manha){
          userFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'tarde'){
        if(c.tarde){
          userFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'noite'){
        if(c.noite){
          userFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'atende_final_de_semana'){
        if(c.atende_fds){
          userFiltrados.add(c);
        }
      }
      if(selectedCategoria == 'atende_festas'){
        if(c.atende_festa){
          userFiltrados.add(c);
        }
      }
    }
    users = userFiltrados;
    inUsers.add(users);
    return;
  }

  Future<String>  updateUser(User user) async {
    if(user.data_nascimento == null){
      user.data_nascimento = DateTime.now();
    }
    user.data_nascimento = user.data_nascimento.subtract(Duration(hours: 3));


    if (user != null) {
        return userRef.document(user.id).updateData(user.toJson()).then((v) {
          inUser.add(user);
          Helper.localUser = user;
          return 'Atualizado com sucesso!';
        }).catchError((err) {
          print('Error: ${err}');
          return 'Error: ${err}';
        });
    } else {
      return Future.delayed(Duration(seconds: 1)).then((v) {
        return 'Erro: Usuário Nulo';
      });
    }
  }

  @override
  void dispose() {
    userController.close();
    usersController.close();
    userSelecionadoController.close();
    // TODO: implement dispose
  }

  void FilterByNome(String s) {
    List<User> userFiltrados = new List();
    if(s == '0'|| s=='') {
      userFiltrados = usersmain;
      users = userFiltrados;
      inUsers.add(users);
    }else{
      for(User c in usersmain) {
        if(c.toString().contains(s)){
          userFiltrados.add(c);
        }
      }
      users = userFiltrados;
      inUsers.add(users);
    }

  }
}
