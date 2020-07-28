

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Objetos/Relatorio.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class RelatoriosController extends BlocBase{

  BehaviorSubject<List<Relatorio>> relatoriosController = BehaviorSubject<List<Relatorio>>();
  Stream<List<Relatorio>> get outRelatorios => relatoriosController.stream;
  Sink<List<Relatorio>> get inRelatorios => relatoriosController.sink;
  List<Relatorio> relatorios;


  RelatoriosController(){
    relatorios = new List();
    if(Helper.localUser.permissao == 10){
      relatoriosRef.getDocuments().then((value) {
        if(value.documents != null){
          for(var d in value.documents){
            print("AQUI RELATORIOS");
            Relatorio r = Relatorio.fromJson(d.data);
            r.id = d.documentID;
            relatorios.add(r);
          }
          relatorios.sort((Relatorio a, Relatorio b){
            return b.created_at.compareTo(a.created_at);
          });
          inRelatorios.add(relatorios);
        }
      });
    }else{
      if(Helper.localUser.campanhas != null){
        for(String s in Helper.localUser.campanhas) {
          relatoriosRef.where('campanha', isEqualTo: s).getDocuments().then((value) {
            if (value.documents != null) {
              for (var d in value.documents) {
                Relatorio r = Relatorio.fromJson(d.data);
                r.id = d.documentID;
                relatorios.add(r);
              }
              relatorios.sort((Relatorio a, Relatorio b) {
                return b.created_at.compareTo(a.created_at);
              });
              inRelatorios.add(relatorios);
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    relatoriosController.close();
  }

}