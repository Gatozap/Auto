

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ParceirosBloc extends BlocBase {
  BehaviorSubject<List<Parceiro>> parceiroController = BehaviorSubject<
      List<Parceiro>>();

  Stream<List<Parceiro>> get outParceiros => parceiroController.stream;

  Sink<List<Parceiro>> get inParceiros => parceiroController.sink;
  List<Parceiro> parceiros;
  List<Parceiro> parceirosmain;
  Parceiro pp;

  BehaviorSubject<Parceiro> parceiroSelecionadoController = BehaviorSubject<Parceiro>();
  Stream<Parceiro> get outParceiroSelecionado => parceiroSelecionadoController.stream;
  Sink<Parceiro> get inParceiroSelecionado => parceiroSelecionadoController.sink;
  Parceiro parceiroSelecionado;

  Future<String>  updateParceiro(Parceiro parceiro) async {




    if (parceiro != null) {
      return parceirosRef.document(parceiro.id).updateData(parceiro.toJson()).then((v) {
        inParceiroSelecionado.add(parceiro);

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

  Future EditarParceiro(Parceiro parceiro) async {


    return parceirosRef.document(parceiro.id).updateData(parceiro.toJson()).then((d) {
      print('editado com sucesso');

      return parceiro;
    }).catchError((err) {
      print('Error: ${err}');
      return err;
    });


  }
  ParceirosBloc(Campanha campanha, {Parceiro parceiro}){
    if(campanha == null) {
      parceiroSelecionado = parceiro;
      inParceiroSelecionado.add(parceiroSelecionado);
      parceirosRef

          .snapshots()
          .listen((QuerySnapshot snap) {
        parceiros = new List();

        if (snap.documents != null) {
          for (DocumentSnapshot ds in snap.documents) {
            Parceiro p = Parceiro.fromJson(ds.data);
            p.id = ds.documentID;
            parceiros.add(p);
          }
          parceiros.sort(
                  (Parceiro a, Parceiro b) => b.id.compareTo(a.id));
          parceirosmain = parceiros;
          inParceiros.add(parceiros);
        } else {
          inParceiros.add(parceiros);
        }
      }).onError((err) {
        print('Erro: ${err.toString()}');
      });
    }else{
      if(campanha.parceiros == null){
        parceiroSelecionado = parceiro;
        inParceiroSelecionado.add(parceiroSelecionado);
        parceirosRef

            .snapshots()
            .listen((QuerySnapshot snap) {
          parceiros = new List();

          if (snap.documents != null) {
            for (DocumentSnapshot ds in snap.documents) {
              Parceiro p = Parceiro.fromJson(ds.data);
              p.id = ds.documentID;
              parceiros.add(p);
            }
            parceiros.sort(
                    (Parceiro a, Parceiro b) => b.id.compareTo(a.id));
            parceirosmain = parceiros;
            inParceiros.add(parceiros);
          } else {
            inParceiros.add(parceiros);
          }
        }).onError((err) {
          print('Erro: ${err.toString()}');
        });
      }else {
        parceiros = campanha.parceiros;
        parceiros.sort(
                (Parceiro a, Parceiro b) => b.id.compareTo(a.id));
        parceirosmain = parceiros;
        inParceiros.add(parceiros);
      }
    }
  }
  @override
  void dispose() {
    parceiroController.close();
    parceiroSelecionadoController.close();


  }
}