import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Pericia.dart';
import 'package:autooh/Objetos/Personagem.dart';
import 'package:rxdart/rxdart.dart';

class PericiasController extends BlocBase{
  BehaviorSubject<List<Pericia>> periciasController = BehaviorSubject<List<Pericia>>();
  Stream<List<Pericia>> get outPericias => periciasController.stream;
  Sink<List<Pericia>> get inPericias => periciasController.sink;
  List<Pericia> pericias;
  List<Pericia> periciasMain;


  PericiasController({aventura}){
    periciasRef.where('isAventureUnique', isEqualTo: false).snapshots().listen((QuerySnapshot snap){
      if(pericias == null){
        pericias = new List();
      }
      if(snap.documents.length > 0) {
        for (DocumentSnapshot ds in snap.documents) {
          Pericia p = Pericia.fromJson(ds.data);
          p.id = ds.documentID;
          pericias.add(p);
        }
        pericias.sort((Pericia a, Pericia b) => a.nome.compareTo(b.nome));
        periciasMain = pericias;
        inPericias.add(pericias);
      }else{
        inPericias.add(pericias);
      }
    }).onError((err){
      print('Erro: ${err.toString()}');
    });

    //periciasRef.where('isAventureUnique', isEqualTo: true).where('aventura',isEqualTo: aventura);
  }

  FiltrarPericiaPorNome(String desc){
    List<Pericia> periciasFiltradas = new List();
    for(Pericia p in periciasMain){
      if(p.nome.toLowerCase().contains(desc.toLowerCase())){
        periciasFiltradas.add(p);
      }
    }
    pericias = periciasFiltradas;
    inPericias.add(pericias);
  }

  FiltrarPericiaPorAtributo(String atributo){
    List<Pericia> periciasFiltradas = new List();
    for(Pericia p in periciasMain){
      if(p.atributo == atributo){
        periciasFiltradas.add(p);
      }
    }
    pericias = periciasFiltradas;
    inPericias.add(pericias);
  }

  @override
  void dispose() {
    periciasController.close();
  }

  List<Pericia> getSuggestions(String pattern,Personagem personagem) {

    List<Pericia> periciasFiltradas = new List();
    for(Pericia p in periciasMain){
      if(p.nome.toLowerCase().contains(pattern.toLowerCase())){
        if(personagem.pericias != null){
          bool contains = false;
          for(Pericia periciaPersonagem in personagem.pericias){
            if(periciaPersonagem.nome == p.nome){
              contains = true;
            }
          }
          if(!contains){
            periciasFiltradas.add(p);
          }

        }else {
          periciasFiltradas.add(p);
        }
      }
    }
    return periciasFiltradas;
  }
}