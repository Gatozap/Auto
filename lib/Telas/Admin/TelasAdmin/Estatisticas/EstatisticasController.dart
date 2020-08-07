import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
class EstatisticaController extends BlocBase {
  BehaviorSubject<List<Corrida>> corridasController =
      BehaviorSubject<List<Corrida>>();
  Stream<List<Corrida>> get outCorridas => corridasController.stream;
  Sink<List<Corrida>> get inCorridas => corridasController.sink;
  List<Corrida> corridas;
  List<Corrida> corridasOriginais;

  BehaviorSubject<double> visualizacoesController = BehaviorSubject<double>();
  Stream<double> get outVisualizacoes => visualizacoesController.stream;
  Sink<double> get inVisualizacoes => visualizacoesController.sink;
  double visualizacoes;

  EstatisticaController(Campanha campanha, Carro carro, User user,
      DateTime dataini, DateTime datafim) {
    if (user == null) {
      if (carro == null) {
        if (campanha == null) {
          if (Helper.localUser.permissao == 5) {
            corridas = new List();
            corridasOriginais = new List();
            if (Helper.localUser.campanhas != null) {
              for (String s in Helper.localUser.campanhas) {
                corridasRef
                    .where('campanha', isEqualTo: s)
                    .getDocuments()
                    .then((v) {
                  for (var i in v.documents) {
                    Corrida p = Corrida.fromJsonFirestore(i.data);
                    p.id = i.documentID;

                    corridas.add(p);
                  }
                  corridasOriginais = corridas;

                  FilterCorridas(dataini, datafim);
                });
              }
            }
          } else {
            corridasRef.getDocuments().then((v) {
              corridas = new List();
              corridasOriginais = new List();

              for (var i in v.documents) {
                Corrida p = Corrida.fromJsonFirestore(i.data);
                p.id = i.documentID;

                corridas.add(p);
              }
              corridasOriginais = corridas;

              FilterCorridas(dataini, datafim);
            });
          }
        } else {
          corridasRef
              .where('campanha', isEqualTo: campanha.id)
              .getDocuments()
              .then((v) {
            corridas = new List();
            corridasOriginais = new List();

            for (var i in v.documents) {
              Corrida p = Corrida.fromJsonFirestore(i.data);
              p.id = i.documentID;

              corridas.add(p);
            }
            corridasOriginais = corridas;

            FilterCorridas(dataini, datafim);
          });
        }
      } else {
        corridasRef
            .where('carro.id', isEqualTo: carro.id)
            .where('hora_ini', isLessThan: dataini.millisecondsSinceEpoch)
            .getDocuments()
            .then((v) {
          corridas = new List();
          corridasOriginais = new List();

          for (var i in v.documents) {
            Corrida p = Corrida.fromJsonFirestore(i.data);
            p.id = i.documentID;

            corridas.add(p);
          }
          corridasOriginais = corridas;
          FilterCorridas(dataini, datafim);
        });
      }
    } else {
      corridasRef
          .where('user', isEqualTo: user.id)
          .limit(20)
          .orderBy('hora_ini', descending: true)
          .where('hora_ini', isGreaterThan: dataini.millisecondsSinceEpoch)
          .snapshots()
          .listen((v) {
        corridas = new List();
        corridasOriginais = new List();
        for (var i in v.documents) {
          Corrida p = Corrida.fromJsonFirestore(i.data);
          p.id = i.documentID;
          corridas.add(p);
        }
        //corridasOriginais = corridas;
        FilterCorridas(dataini, datafim);
      });
    }
  }

  @override
  void dispose() {
    corridasController.close();
    visualizacoesController.close();
  }

  void FilterCorridas(DateTime dataini, DateTime datafim) {
    print("INICOU AQUI");
    List<Corrida> corridasTemp = new List();
    for (Corrida c in corridas) {
      bool contains = false;
      for (Corrida c1 in corridasTemp) {
        if (c.id == c1.id) {
          contains = true;
        }
      }
      if (datafim != null && dataini != null) {
        if (!contains) {
          if (dataini != null &&
              datafim != null &&
              c.hora_fim != null &&
              c.hora_ini != null) {
            if (dataini.isBefore(c.hora_ini) && datafim.isAfter(c.hora_fim)) {
              corridasTemp.add(c);
            }
          }
        }
      } else {
        if (!contains) {
          corridasTemp.add(c);
        }
      }
    }
    corridas = corridasTemp;
    print('COrridas ${corridas.length}');
    if (corridas.length == 0) {
      dToast('Sem corridas neste periodo');
    }
    corridas.sort((Corrida a, Corrida b) => b.id.compareTo(a.id));
    inCorridas.add(corridas);
  }
}
