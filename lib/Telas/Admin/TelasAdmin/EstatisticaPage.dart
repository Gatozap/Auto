import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Distancia.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/Estatisticas/EstatisticasController.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';





class EstatisticaPage extends StatefulWidget {

  Carro carro;
  User user;
  Campanha campanha;
  Corrida corrida;

  EstatisticaPage({Key key, this.carro, this.campanha, this.user,this.corrida}) : super(key: key);

  @override
  _EstatisticaPageState createState() {
    return _EstatisticaPageState();
  }
}



class _EstatisticaPageState extends State<EstatisticaPage> {
  EstatisticaController estController;
  DateTime dataini = DateTime.now().subtract(Duration(days: 30));
  DateTime datafim = DateTime.now();
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(estController == null){
      estController = new EstatisticaController();
    }
    // TODO: implement build
    return Scaffold(appBar: myAppBar('Estatística', context),
    body: Container(child:
       StreamBuilder(
         stream: estController.outCorridas,
         builder: (context, snapshot) {
             if(snapshot.data == null){
               return Container(child: hText('aqui', context),);
             }
           return Column(children: <Widget>[

             getEstatisticasWidget(snapshot.data)

           ],);
         }
       ),
    ),);
  }


   getEstatisticasWidget(List<Corrida> corridas){
    double visualizacoes = 0;
    double dist = 0;

         String id_corrida = '';
     List<Corrida> corridasFiltradas = new List();
     for(Corrida c in corridas){


                          visualizacoes +=
                          c.vizualizacoes == null ? 0 : c.vizualizacoes;
                          dist += c.dist == null ? 0 : c.dist;
                          corridasFiltradas.add(c);
                        

      corridas = corridasFiltradas;
        estController.inCorridas.add(corridas);
     }
     return hText('Total de visualizações: ${visualizacoes} dist: ${dist}', context);

   }

   getMediaWidget(List<Campanha> campanhas){
    double totaldeCampanhas = 0;
    List<Campanha> campanha = new List();
    for(Campanha cc in campanhas){
           
    }
    
   }
  /*EstatisticasGeraisWidget(List<Corrida> corridas) {
    double totalcorrida = 0;
    List corridas = new List();
    double maiorcorrida = 0;
    DateTime maiorCorridaData = DateTime.now();

    for (Corrida p in corridas) {
      bool contains = false;
      for (String s in carros) {
        if (s == p.carros) {
          contains = true;
        }
      }
      if (!contains) {
        carros.add(p.carros);
      }

        maiscarros = p.carros;
        maiorVendaData = p.data_venda;
        mvComprador = p.comprador;

      total += p.total;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Pedidos: ${pagamentos.length}'),
            Text('Total em Vendas: R\$${total.toStringAsFixed(2)}'),
            Text('Clientes Atendidos: ${clientes.length}'),
            Divider(),
            Text(
                'Maior Venda: R\$${maiorVenda.toStringAsFixed(2)} no Dia: ${maiorVendaData.day}/${maiorVendaData.month}'),
            FutureBuilder(
                builder: (context, snap) {
                  if (snap.data == null) {
                    return Container();
                  }
                  print(snap.data.toString());
                  DocumentSnapshot d = snap.data;
                  print(d.data);
                  if (d.data == null) {
                    return Container();
                  }
                  User c = User.fromJson(d.data);
                  return Text(
                    'Comprador: ${c.nome}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                },
                future: userRef.document(mvComprador).get())
          ],
        ),
      ),
    );
  }  */

  List<ColumnSeries<Corrida, DateTime>> getLineSeries(List<Corrida> corrida){
    
  }
  GraficosWidget(List<Corrida> corrida, List<Campanha> campanha,
      DateTime dataini, DateTime datafim) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Container(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container()
            ),
          ),
        ),

      ],
    );
  }


  }
