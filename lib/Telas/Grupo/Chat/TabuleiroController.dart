import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Tabuleiro.dart';
import 'package:rxdart/rxdart.dart';

class TabuleiroController extends BlocBase{
  BehaviorSubject<Tabuleiro> tabuleiroController = new BehaviorSubject<Tabuleiro>();
  Stream<Tabuleiro> get outTabuleiro => tabuleiroController.stream;
  Sink<Tabuleiro> get inTabuleiro => tabuleiroController.sink;

  TabuleiroController(String aventura){
   tabuleirosRef.where('aventura', isEqualTo: aventura).snapshots().listen((QuerySnapshot snaps){
     if(snaps.documents == null){
      Tabuleiro t = new Tabuleiro(aventura: aventura,altura: 50, largura:30,);
      tabuleirosRef.add(t.toJson()).then((v){
        t.id = v.documentID;
        tabuleirosRef.document(t.id).updateData(t.toJson());
        inTabuleiro.add(t);
      });
      return;
     }
     if(snaps.documents.length == 0) {
         Tabuleiro t = new Tabuleiro(
           aventura: aventura, altura: 50, largura: 30,);
         tabuleirosRef.add(t.toJson()).then((v) {
           t.id = v.documentID;
           tabuleirosRef.document(t.id).updateData(t.toJson());
           inTabuleiro.add(t);

         });
         return;
       }
     Tabuleiro t = Tabuleiro.fromJson(snaps.documents[0].data);
     inTabuleiro.add(t);
   });
  }

  @override
  void dispose() {
    tabuleiroController.close();
  }

}