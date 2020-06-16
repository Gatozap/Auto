import 'dart:async';

import 'dart:typed_data';

import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:geocoder/geocoder.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'Helper.dart';
import 'dart:io';
import 'References.dart';

class GeradorPDF {
  int diaInicial;
  int diaFinal;
  List<Corrida> corridas;
  List localizacoes;
  File png;
  Future<Uint8List> buildPdf() async {
    double visualizacoes = 0;
    double visualizacoesTempo = 0;
    double visualizacoesKm = 0;
    double dist = 0;
    List<Carro> carroIds = new List();
    int countCorridas = 0;
    Map<String, List<Localizacao>> zonas = Map();
    countCorridas = corridas.length;
    List<String> campanhas = new List();
    var tempoNaRua = 0.0;
    List localizacoes;
    List<Campanha> campanhasList;
    double valor = 0;
    for (Corrida c in corridas) {
      bool contains = false;
      for (String s in campanhas) {
        if (s == c.campanha) {
          contains = true;
        }
      }
      if (!contains && c.campanha != null) {
        campanhas.add(c.campanha);
      }
    }
    if (campanhasList == null) {
      List<Campanha> campanhasList = new List();
      for (String s in campanhas) {

        Campanha c = Campanha.fromJson(
            (        (await campanhasRef.document(s).get()).data));
        campanhasList.add(c);
      }
      Map bairros = new Map();
      for (Campanha c in campanhasList) {
        double dist = 0;
        double valorTemp = 0;
        for (Corrida cor in corridas) {
          if (c.id == cor.campanha) {
            dist += cor.dist == null ? 0 : cor.dist;
          }
        }
        if (c.precomes != null && c.kmMinima != null) {
          if (c.kmMinima != 0) {
            valorTemp += ((dist / 1000) / c.kmMinima);
          }
        }
        if (valorTemp > 100) {
          valorTemp = c.precomes;
        } else {
          valorTemp = c.precomes * valorTemp;
        }
        if (valorTemp > c.precomes) {
          valorTemp = c.precomes;
        }
        valor += valorTemp;
      }


      localizacoes = new List();
      for (Corrida c in corridas) {
        visualizacoes += c.vizualizacoes == null ? 0 : c.vizualizacoes;
        visualizacoesTempo +=
        c.vizualizacoes_por_tempo == null ? 0 : c.vizualizacoes_por_tempo;
        visualizacoesKm += c.vizualizacoes_por_distancia == null
            ? 0
            : c.vizualizacoes_por_distancia;
        dist += c.dist == null ? 0 : c.dist;
        tempoNaRua += c.duracao;
        bool containsCarro = false;
        for (Carro s in carroIds) {
          if (s.placa == c.carro.placa) {
            containsCarro = true;
          }
        }
        for (Localizacao p in c.points) {
          if (zonas[p.zona] == null) {
            zonas[p.zona] = new List();
            ;
          }
          zonas[p.zona].add(p);
          if(p.bairro == null){
            var addresses = await Geocoder.local.findAddressesFromCoordinates(
                Coordinates(p.latitude, p.longitude));
            var first = addresses.first;

            p.bairro='${first.subLocality}';
          }
          if(bairros[p.bairro] == null){
            bairros[p.bairro] = new List();
          }
          bairros[p.bairro].add(p);
        }
        if (!containsCarro) {
          carroIds.add(c.carro);
        }

        localizacoes.addAll(c.points);
      }
      int carros = carroIds.length;

      corridas.sort((Corrida a, Corrida b) {
        return a.hora_ini.compareTo(b.hora_ini);
      });
      double totalPercorrido = 0;
      double totalPercorridoBairros = 0;

      List<List> textosZonas = new List();
      List<List> textosBairros = new List();
      bairros.forEach((k, v) {
        print('AQUI LOLOL BAIRRO $k $v');
        Localizacao lastPoint;
        double dist = 0;
        double tempo = 0;
        for (Localizacao p in v) {
          if (lastPoint != null) {
            var distTemp = calculateDistance(
              p.latitude,
              p.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
            );
            if (distTemp < 300) {
              dist += distTemp;
            }
            tempo += p.timestamp.difference(lastPoint.timestamp).inMilliseconds;
          }
          lastPoint = p;
        }
        totalPercorridoBairros+=dist;
        textosBairros.add(['${k[0].toUpperCase()}${k.substring(1).toLowerCase()}',dist ,tempo]);
      });
      zonas.forEach((k, v) {
        Localizacao lastPoint;
        double dist = 0;
        double tempo =0;
        for (Localizacao p in v) {
          if (lastPoint != null) {
            var distTemp = calculateDistance(
              p.latitude,
              p.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
            );
            if (distTemp < 300) {
              dist += distTemp;
            }
            tempo += p.timestamp.difference(lastPoint.timestamp).inMilliseconds;
          }
          lastPoint = p;

        }
        totalPercorrido+=dist;
        textosZonas.add(['${k[0].toUpperCase()}${k.substring(1).toLowerCase()}',dist ,tempo]);

      });
      textosBairros.sort((var a, var b){
        return b[1].compareTo(a[1]);
      });
      textosZonas.sort((var a, var b){
        return b[1].compareTo(a[1]);
      });

      List<String> percentuaisBairros = new List();
      double totalPercentualBairros = 0;
      for(var i in textosBairros){
        print("AQUI PERCENTUAL  (${totalPercorrido}-${i[1]})/${totalPercorrido} =${ (((i[1]-totalPercorrido)/totalPercorrido)+1)}");
        double percentual = (((i[1]-totalPercorrido)/totalPercorrido)+1);
        percentuaisBairros.add((percentual*100).toStringAsFixed(2));
        totalPercentualBairros +=percentual;
      }
      print("AQUI TOTAL $totalPercentualBairros");
      List<String> percentuais = new List();
      double totalPercentual = 0;
      for(var i in textosZonas){
        print("AQUI PERCENTUAL  (${totalPercorrido}-${i[1]})/${totalPercorrido} =${ (((i[1]-totalPercorrido)/totalPercorrido)+1)}");
        double percentual = (((i[1]-totalPercorrido)/totalPercorrido)+1);
        percentuais.add((percentual*100).toStringAsFixed(2));
        totalPercentual +=percentual;
      }
      print("AQUI TOTAL $totalPercentual");

      DateTime dini = DateTime.fromMillisecondsSinceEpoch(diaInicial);
      DateTime dfim = DateTime.fromMillisecondsSinceEpoch(diaFinal);
      final Document pdf = Document(
          title:
          'Relatorio ${dini.toIso8601String()} - ${dfim.toIso8601String()} ',
          author: 'Autooh');
      List<Row> rows = new List();
      rows.add(Row(children: [Container(height: 20)]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Vizualizações por distancia: ${visualizacoesKm}")),
      ]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Vizualizações por Tempo: ${visualizacoesTempo}")),
      ]));
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text('Total Vizualizações: ${visualizacoes}')),
      ]));

      rows.add(Row(children: [Container(height: 20)]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Valor: R\$${valor.toStringAsFixed(2)}")),
      ]));

      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Tempo na Rua: ${(tempoNaRua / 60).toStringAsFixed(2)} minutos")),
      ]));

      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Distancia Percorrida: ${totalPercorrido.toStringAsFixed(2)}")),
      ]));


      rows.add(Row(children: [Container(height: 20)]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Carros: ${carroIds.length}")),
      ]));
      for (Carro s in carroIds) {
        rows.add(Row(children: [
          Container(
              width: 600,
              decoration: BoxDecoration(
                  border: BoxBorder(
                      width: 2, color: PdfColor.fromRYB(0, 0, 0))),
              child: Text('${s.modelo} - ${s.cor} - ${s.placa}')),
        ]));
      }

      rows.add(Row(children: [Container(height: 20)]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Zonas")),
      ]));

      for(int i = 0; i<textosZonas.length ;i++ ){
        rows.add(Row(children: [
          Container(
              width: 600,
              decoration: BoxDecoration(
                  border: BoxBorder(
                      width: 2, color: PdfColor.fromRYB(0, 0, 0))),
              child: Text('${textosZonas[i][0]}',style: TextStyle(fontWeight: FontWeight.bold))),
        ]));
        rows.add(Row(children: [
          Container(
              width: 600,
              decoration: BoxDecoration(
                  border: BoxBorder(
                      width: 2, color: PdfColor.fromRYB(0, 0, 0))),
              child: Text('Distancia Percorrida: ${textosZonas[i][1].toStringAsFixed(2)}Km,\nProporção: %${percentuais[i]}')),
        ]));
        rows.add(Row(children: [
          Container(
              width: 600,
              decoration: BoxDecoration(
                  border: BoxBorder(
                      width: 2, color: PdfColor.fromRYB(0, 0, 0))),
              child: Text('Tempo: ${((((textosZonas[i][2]/100000)/60))).toStringAsFixed(1)} minutos\n')),
        ]));
        rows.add(Row(children: [Container(height: 20)]));
      }

      rows.add(Row(children: [Container(height: 20)]));
      rows.add(Row(children: [
        Container(
            width: 600,
            decoration: BoxDecoration(
                border: BoxBorder(width: 2, color: PdfColor.fromRYB(0, 0, 0))),
            child: Text("Bairros")),
      ]));

      print("AQUI BAIRROS LENGTH ${textosBairros.length}");
      for(int i = 0; i<textosBairros.length ;i++ ){
        if(textosBairros[i][1].toStringAsFixed(2) != '0.00') {
          rows.add(Row(children: [
            Container(
                width: 600,
                decoration: BoxDecoration(
                    border: BoxBorder(
                        width: 2, color: PdfColor.fromRYB(0, 0, 0))),
                child: Text('${textosBairros[i][0]}',style: TextStyle(fontWeight: FontWeight.bold))),
          ]));
          rows.add(Row(children: [
            Container(
                width: 600,
                decoration: BoxDecoration(
                    border: BoxBorder(
                        width: 2, color: PdfColor.fromRYB(0, 0, 0))),
                child: Text('Distancia Percorrida: ${textosBairros[i][1]
                    .toStringAsFixed(
                    2)}Km,\nProporção: ${percentuaisBairros[i]}')),
          ]));
          rows.add(Row(children: [
            Container(
                width: 600,
                decoration: BoxDecoration(
                    border: BoxBorder(
                        width: 2, color: PdfColor.fromRYB(0, 0, 0))),
                child: Text('Tempo: ${((((textosBairros[i][2]/100000)/60))).toStringAsFixed(1)} minutos\n')),
          ]));
          rows.add(Row(children: [Container(height: 20)]));
        }
      }


      final image = PdfImage.file(
        pdf.document,
        bytes: png.readAsBytesSync(),
      );



      pdf.addPage(MultiPage(
          pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
          crossAxisAlignment: CrossAxisAlignment.start,
          header: (Context context) {
            return Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                    'Autooh, Periodo ${dini.day}/${dini.month}/${dini
                        .year} - ${dfim.day}/${dfim.month}/${dfim.year}',
                    style: TextStyle(
                      fontSize: 16,
                    )));
          },
          footer: (Context context) {
            return Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: Text(
                    'Pagina ${context.pageNumber} de ${context.pagesCount}',
                    style: Theme
                        .of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.grey)));
          },
          build: (Context context) => rows));
      pdf.addPage(Page(
          build: (Context context) {
            return Center(
              child: Image(image),
            ); // Center
          }));
      return Uint8List.fromList(pdf.save());
    }
  }

  Future<Uint8List> GerarPDF(
      List<Corrida> corridas,
      File png,
      int diaInicial,
      int diaFinal,) {
    this.diaInicial = diaInicial;
    this.diaFinal = diaFinal;
    this.corridas = corridas;
    this.png = png;
    return buildPdf();
   /* js.context['buildPdf'] = buildPdf;
    Timer.run(() {
      js.context.callMethod('ready');
    });*/

  }
}
