import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Despesa.dart';
import 'package:autooh/Objetos/Pagamento.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'CadastrarDespesaPage.dart';

class EstatisticasPage extends StatefulWidget {
  @override
  _EstatisticasPageState createState() {
    return _EstatisticasPageState();
  }
}

class _EstatisticasPageState extends State<EstatisticasPage> {
  EstatisticasController ec;
  DateTime dataini = DateTime.now().subtract(Duration(days: 30));
  DateTime datafim = DateTime.now();
  @override
  Widget build(BuildContext context) {
    if (ec == null) {
      ec = EstatisticasController();
    }
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
        'Estatisticas',
        context,
        actions: [
          IconButton(
            icon: Icon(
              LineAwesomeIcons.calendar,
            ),
            onPressed: () async {
              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: new DateTime.now(),
                  initialLastDate:
                      (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: new DateTime(2015),
                  lastDate: new DateTime(2040));
              if (picked != null && picked.length == 2) {
                dataini = picked[0];
                datafim = picked[1];
                print(picked);
                ec.FiltrarPorData(picked[0], picked[1]);
              }
            },
          ),
          IconButton(
            icon: Icon(
              LineAwesomeIcons.plus_circle,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CadastrarDespesaPage()));
            },
          ),
        ],
        showBack: true,
      ),
      body: Container(
        child: SSB(
            error: Center(
              child: Text('Erro ao buscar Vendas'),
            ),
            emptylist: SSB(
                error: Center(child: Text('Sem dados para esse período')),
                emptylist: Center(child: Text('Sem dados para esse período')),
                stream: ec.outDespesas,
                isList: true,
                buildfunction: (context, despesas) {
                  return SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      GraficosWidget(
                          List<Pagamento>(), despesas.data, dataini, datafim),
                      //EstatisticasGeraisWidget(List<Pagamento>()),
                    ],
                  ));
                }),
            stream: ec.outPagamentos,
            isList: true,
            buildfunction: (context, snap) {
              return SSB(
                  error: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      GraficosWidget(
                          snap.data, List<Despesa>(), dataini, datafim),
                      EstatisticasGeraisWidget(snap.data),
                    ],
                  )),
                  emptylist: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GraficosWidget(
                            snap.data, List<Despesa>(), dataini, datafim),
                        EstatisticasGeraisWidget(snap.data),
                      ],
                    ),
                  ),
                  stream: ec.outDespesas,
                  isList: true,
                  buildfunction: (context, despesas) {
                    return SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        GraficosWidget(
                            snap.data, despesas.data, dataini, datafim),
                        EstatisticasGeraisWidget(snap.data),
                      ],
                    ));
                  });
            }),
      ),
    );
  }

  List<ColumnSeries<_ChartNumeric, DateTime>> getLineSeries(
      bool isTileView,
      List<Pagamento> pagamentos,
      List<Despesa> despesas,
      DateTime datini,
      DateTime datafim) {
    List<_ChartNumeric> chartData = List();
    print('DIFERENCA VADIA ${datafim.difference(dataini).inDays}');
    double totalvendas = 0;
    double totaldespesas = 0;
    for (var i = 0; i <= datafim.difference(dataini).inDays; i++) {
      DateTime data = datafim.subtract(Duration(days: i));
      double vendasDoDia = 0;
      double despesasDoDia = 0;
      String refy = '';
      String refy2 = '';

      for (Pagamento p in pagamentos) {
        if (p.data_venda.day == data.day &&
            p.data_venda.month == data.month &&
            p.data_venda.year == data.year) {
          vendasDoDia += p.total;
          totalvendas += p.total;
          refy2 +=
              '${p.forma_pagamento == 'Cartao' ? 'In App Purchase' : p.forma_pagamento}: ${p.total.toStringAsFixed(2)}\n';
        }
      }
      for (Despesa d in despesas) {
        if (d.repetivel) {
          switch (d.tipo) {
            case 0:
              despesasDoDia += d.valor;
              //tipo = 'Diario';
              totaldespesas += d.valor;
              refy += '${d.descricao}: ${d.valor.toStringAsFixed(2)}\n';
              break;
            case 1:
              if (d.data_pagamento.day == data.day) {
                despesasDoDia += d.valor;
                totaldespesas += d.valor;
                refy += '${d.descricao}: ${d.valor.toStringAsFixed(2)}\n';
              }
              //tipo = 'Mensal';
              break;
            case 2:
              if (d.data_pagamento.day == data.day &&
                  d.data_pagamento.month == data.month) {
                despesasDoDia += d.valor;
                totaldespesas += d.valor;
                refy += '${d.descricao}: ${d.valor.toStringAsFixed(2)}\n';
              }
              //tipo = 'Anual';
              break;
            case 3:
              // = 'Unico';
              if (d.data_pagamento.day == data.day &&
                  d.data_pagamento.month == data.month &&
                  d.data_pagamento.year == data.year) {
                despesasDoDia += d.valor;
                totaldespesas += d.valor;
                refy += '${d.descricao}: ${d.valor.toStringAsFixed(2)}\n';
              }
              break;
          }
        } else {
          if (d.data_pagamento.day == data.day &&
              d.data_pagamento.month == data.month &&
              d.data_pagamento.year == data.year) {
            despesasDoDia += d.valor;
            totaldespesas += d.valor;
            refy += '${d.descricao}:${d.valor.toStringAsFixed(2)}\n';
          }
        }
      }
      print('DATA AQUI ${data.day}/${data.month}');
      chartData.add(
        _ChartNumeric(data, despesasDoDia, vendasDoDia, refy, refy2),
      );
    }

    return <ColumnSeries<_ChartNumeric, DateTime>>[
      ColumnSeries<_ChartNumeric, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          color: corPrimaria,
          xAxisName: 'Data',
          xValueMapper: (_ChartNumeric sales, _) => sales.x,
          yValueMapper: (_ChartNumeric sales, _) => sales.y2,
          name: 'Vendas:\nR\$${totalvendas.toStringAsFixed(2)}'),
      ColumnSeries<_ChartNumeric, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          xAxisName: 'Data',
          color: myOrange,
          xValueMapper: (_ChartNumeric sales, _) => sales.x,
          yValueMapper: (_ChartNumeric sales, _) => sales.y,
          name: 'Despesas:\nR\$${totaldespesas.toStringAsFixed(2)}'),
    ];
  }

  List<ColumnSeries<ChartPagamento, DateTime>> getPagamentoSeries(
      bool isTileView,
      List<Pagamento> pagamentos,
      DateTime datini,
      DateTime datafim) {
    List<ChartPagamento> chartData = List();
    print('DIFERENCA VADIA ${datafim.difference(dataini).inDays}');
    double totalinapp = 0;
    double totalmaquina = 0;
    double totaldinheiro = 0;
    for (var i = 0; i <= datafim.difference(dataini).inDays; i++) {
      DateTime data = datafim.subtract(Duration(days: i));
      double dinheiro = 0;
      double maquina = 0;
      double inapp = 0;

      String refy = '';

      for (Pagamento p in pagamentos) {
        if (p.data_venda.day == data.day &&
            p.data_venda.month == data.month &&
            p.data_venda.year == data.year) {
          switch (p.forma_pagamento) {
            case 'Cartao':
              inapp += p.total;
              totalinapp += p.total;
              break;
            case 'Dinheiro':
              dinheiro += p.total;
              totaldinheiro += p.total;
              break;
            case 'Maquininha':
              maquina += p.total;
              totalmaquina += p.total;
          }
          refy +=
              '${p.forma_pagamento == 'Cartao' ? 'In App Purchase' : p.forma_pagamento}: ${p.total.toStringAsFixed(2)}\n';
        }
      }
      print('DATA AQUI ${data.day}/${data.month}');
      chartData.add(
        ChartPagamento(
          data,
          inapp,
          dinheiro,
          maquina,
          refy,
        ),
      );
    }

    return <ColumnSeries<ChartPagamento, DateTime>>[
      ColumnSeries<ChartPagamento, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          color: corPrimaria,
          xAxisName: 'In App Purchase',
          xValueMapper: (ChartPagamento sales, _) => sales.x,
          yValueMapper: (ChartPagamento sales, _) => sales.y,
          name: 'In App:\nR\$${totalinapp.toStringAsFixed(2)}'),
      ColumnSeries<ChartPagamento, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          xAxisName: 'Data',
          color: myBlue,
          xValueMapper: (ChartPagamento sales, _) => sales.x,
          yValueMapper: (ChartPagamento sales, _) => sales.y2,
          name: 'Dinheiro:\nR\$${totaldinheiro.toStringAsFixed(2)}'),
      ColumnSeries<ChartPagamento, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          xAxisName: 'Data',
          color: myYellow,
          xValueMapper: (ChartPagamento sales, _) => sales.x,
          yValueMapper: (ChartPagamento sales, _) => sales.y3,
          name: 'Maquinha:\nR\$${totalmaquina.toStringAsFixed(2)}'),
    ];
  }

  GraficosWidget(List<Pagamento> pagamentos, List<Despesa> despesas,
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
              child: getDefaultNumericAxisChart(
                  false, pagamentos, despesas, dataini, datafim),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Container(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: getGraficoFormasDePagamento(
                  false, pagamentos, dataini, datafim),
            ),
          ),
        ),
      ],
    );
  }

  SfCartesianChart getDefaultNumericAxisChart(bool isTileView, pagamentos,
      despesas, DateTime dataini, DateTime datafim) {
    return SfCartesianChart(
      title: ChartTitle(
          text: isTileView
              ? ''
              : 'de: ${dataini.day} - ${getMonthString(dataini.month)} - ${dataini.year} \n a: ${datafim.day} - ${getMonthString(datafim.month)} - ${datafim.year} '),
      plotAreaBorderWidth: 0,
      legend: Legend(
          isVisible: isTileView ? false : true, position: LegendPosition.top),
      primaryXAxis: DateTimeAxis(dateFormat: DateFormat('d/M')),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isTileView ? '' : ''),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getLineSeries(isTileView, pagamentos, despesas, dataini, datafim),
      tooltipBehavior: TooltipBehavior(
          builder: (data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            String vendas = 'Nenhuma';
            try {
              vendas =
                  '${data.refy2.toString().replaceRange(data.refy2.toString().length - 1, data.refy2.toString().length, '')}';
            } catch (erro) {
              print('Error:${erro.toString()}');
            }
            String despesas = 'Nenhuma';
            try {
              despesas =
                  '${data.refy.toString().replaceRange(data.refy.toString().length - 1, data.refy.toString().length, '')}';
            } catch (erro) {
              print('Error:${erro.toString()}');
            }

            print('DATA ${data}, ${point}, ${series},${pointIndex}');
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Despesas:\n${despesas}\n'
                      'Vendas:\n${vendas}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            );
          },
          enable: true,
          duration: 10000,
          canShowMarker: true),
    );
  }

  EstatisticasGeraisWidget(List<Pagamento> pagamentos) {
    double total = 0;
    List clientes = new List();
    double maiorVenda = 0;
    DateTime maiorVendaData = DateTime.now();
    String mvComprador = '';
    for (Pagamento p in pagamentos) {
      bool contains = false;
      for (String s in clientes) {
        if (s == p.comprador) {
          contains = true;
        }
      }
      if (!contains) {
        clientes.add(p.comprador);
      }
      if (p.total > maiorVenda) {
        maiorVenda = p.total;
        maiorVendaData = p.data_venda;
        mvComprador = p.comprador;
      }
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
  }

  SfCartesianChart getGraficoFormasDePagamento(bool isTileView,
      List<Pagamento> pagamentos, DateTime dataini, DateTime datafim) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Formas de Pagamento'),
      plotAreaBorderWidth: 0,
      legend: Legend(
          isVisible: isTileView ? false : true, position: LegendPosition.top),
      primaryXAxis: DateTimeAxis(dateFormat: DateFormat('d/M')),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isTileView ? '' : ''),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getPagamentoSeries(isTileView, pagamentos, dataini, datafim),
      tooltipBehavior: TooltipBehavior(
          builder: (data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            String despesas = 'Nenhuma';
            try {
              despesas =
                  '${data.refy.toString().replaceRange(data.refy.toString().length - 1, data.refy.toString().length, '')}';
            } catch (erro) {
              print('Error:${erro.toString()}');
            }

            print('DATA ${data}, ${point}, ${series},${pointIndex}');
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      despesas,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            );
          },
          enable: true,
          duration: 10000,
          canShowMarker: true),
    );
  }
}

class _ChartNumeric {
  _ChartNumeric(this.x, this.y, this.y2, this.refy, this.refy2);
  final DateTime x;
  final double y;
  final double y2;
  final String refy;
  final String refy2;
}

class ChartPagamento {
  ChartPagamento(
    this.x,
    this.y,
    this.y2,
    this.y3,
    this.refy,
  );
  final DateTime x;
  final double y;
  final double y2;
  final double y3;
  final String refy;
}

class EstatisticasController extends BlocBase {
  BehaviorSubject<List<Pagamento>> controllerPagamentos =
      BehaviorSubject<List<Pagamento>>();
  Stream<List<Pagamento>> get outPagamentos => controllerPagamentos.stream;
  Sink<List<Pagamento>> get inPagamentos => controllerPagamentos.sink;
  List<Pagamento> pagamentos;

  BehaviorSubject<List<Despesa>> controllerDespesas =
      BehaviorSubject<List<Despesa>>();
  Stream<List<Despesa>> get outDespesas => controllerDespesas.stream;
  Sink<List<Despesa>> get inDespesas => controllerDespesas.sink;
  List<Despesa> despesas;

  EstatisticasController() {
    pagamentoRef
        .where('prestador', isEqualTo: Helper.localUser.prestador)
        .snapshots()
        .listen((v) {
      pagamentos = new List();
      for (var i in v.documents) {
        Pagamento p = Pagamento.fromJson(i.data);
        p.id = i.documentID;
        pagamentos.add(p);
      }
      pagamentos.sort(
          (Pagamento a, Pagamento b) => b.data_venda.compareTo(a.data_venda));
      inPagamentos.add(pagamentos);
    });
    despesasRef
        .where('prestador', isEqualTo: Helper.localUser.prestador)
        .snapshots()
        .listen((v) {
      despesas = new List();
      for (var i in v.documents) {
        Despesa d = Despesa.fromJson(i.data);
        d.id = i.documentID;
        despesas.add(d);
      }
      despesas.sort((Despesa a, Despesa b) =>
          b.data_pagamento.compareTo(a.data_pagamento));
      inDespesas.add(despesas);
    });
  }
  FiltrarPorData(DateTime a, DateTime b) {
    pagamentoRef
        .where('prestador', isEqualTo: Helper.localUser.prestador)
        .where('data_venda', isGreaterThan: a.millisecondsSinceEpoch)
        .where('data_venda', isLessThan: b.millisecondsSinceEpoch)
        .getDocuments()
        .then((v) {
      pagamentos = new List();
      for (var i in v.documents) {
        Pagamento p = Pagamento.fromJson(i.data);
        p.id = i.documentID;
        pagamentos.add(p);
      }
      pagamentos.sort(
          (Pagamento a, Pagamento b) => b.data_venda.compareTo(a.data_venda));
      inPagamentos.add(pagamentos);
    });
    despesasRef
        .where('prestador', isEqualTo: Helper.localUser.prestador)
        .snapshots()
        .listen((v) {
      despesas = new List();
      for (var i in v.documents) {
        Despesa d = Despesa.fromJson(i.data);
        d.id = i.documentID;
        despesas.add(d);
      }
      despesas.sort((Despesa a, Despesa b) =>
          b.data_pagamento.compareTo(a.data_pagamento));
      inDespesas.add(despesas);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerPagamentos.close();
    controllerDespesas.close();
  }
}
