import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Grupo.dart';
import 'package:rxdart/rxdart.dart';

class GruposController extends BlocBase{
  String erro = 'Erro Grupos Controller: ';
  BehaviorSubject<List<Grupo>> controllerGrupos = BehaviorSubject<List<Grupo>>();
  Stream<List<Grupo>> get outGrupos => controllerGrupos.stream;
  Sink<List<Grupo>> get inGrupos => controllerGrupos.sink;
  List<Grupo> grupos;


  GruposController(){
    gruposRef.where('membros',arrayContains: Helper.localUser.id).snapshots().listen((QuerySnapshot data){
      grupos = new List();
      for(DocumentSnapshot ds in data.documents){
        grupos.add(Grupo.fromJson(ds.data));
      }
      inGrupos.add(grupos);
    }).onError((err){
      print('$erro 1 ${err.toString()}');
      return false;
    });
  }


  Future<bool> CadastrarGrupo(Grupo g){
    return gruposRef.add(g.toJson()).then((v){
      return true;
    }).catchError((err){
      print('$erro 2 ${err.toString()}');
      return false;
    });
  }
  @override
  void dispose() {
    controllerGrupos.close();
  }
}

GruposController gc = GruposController();