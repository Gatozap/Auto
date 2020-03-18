import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Equipamento.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:rxdart/subjects.dart';

class EquipamentosController extends BlocBase {
  BehaviorSubject<String> listaSlotBloc =
  BehaviorSubject<String>();
  Stream<String> get outSlot => listaSlotBloc.stream;
  Sink<String> get inSlot => listaSlotBloc.sink;

  BehaviorSubject<List<Equipamento>> equipamentosController =
  BehaviorSubject<List<Equipamento>>();

  Sink<List<Equipamento>> get inEquipamentos => equipamentosController.sink;

  Stream<List<Equipamento>> get outEquipamentos =>
      equipamentosController.stream;
  List<Equipamento> equipamentos;
  List<Equipamento> equipamentosMain;

  EquipamentosController({aventura}) {
    equipamentosRef.snapshots().listen((QuerySnapshot snap) {
      if (equipamentos == null) {
        equipamentos = new List();
      }
      for (DocumentSnapshot ds in snap.documents) {
        Equipamento e = Equipamento.fromJson(ds.data);
        e.id = ds.documentID;
        equipamentos.add(e);
      }
      print('AQUI EQUIPAMENTOS ${equipamentos}');
      equipamentosMain = equipamentos;
      inEquipamentos.add(equipamentos);
    });
  }


  FiltrarTalentoPorNome(String desc) {
    List<Equipamento> equipamentosFiltrados = new List();
    for (Equipamento e in equipamentosMain) {
      if (e.nome.toLowerCase().contains(desc.toLowerCase())) {
        equipamentosMain.add(e);
      }
    }
    equipamentos = equipamentosFiltrados;
    inEquipamentos.add(equipamentos);
  }

  List<Equipamento> getSuggestions(String pattern, Personagem personagem) {
    List<Equipamento> equipamentosFiltrados = new List();
    for (Equipamento e in equipamentosMain) {
      if (e.nome.toLowerCase().contains(pattern.toLowerCase())) {
        if (personagem.equipamentos != null) {
          bool contains = false;
          for (Equipamento equipamentosPersonagem in personagem.equipamentos) {
            if (equipamentosPersonagem.nome == e.nome) {
              contains = true;
            }
          }
          if (!contains) {
            equipamentosFiltrados.add(e);
          }
        } else {
          equipamentosFiltrados.add(e);
        }
      }
    }
    return equipamentosFiltrados;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}