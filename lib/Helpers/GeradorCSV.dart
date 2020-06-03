

import 'dart:convert';

import 'package:autooh/Objetos/Corrida.dart';
import 'package:csv/csv.dart';
import 'dart:html' as html; // or package:universal_html/prefer_universal/html.dart

class GeradorCSV{
  List<Corrida> corridas;
  int diaInicial;
  int diaFinal;
  List<List<dynamic>> linhas = new List();

  gerarCsv(){

    linhas.add(
      ["Data", "Hora","Usuario","Tipo","ValorTransacao",]
    );
    for(Corrida corrida in corridas){
      //linhas.add(transacao.toCSV());
    }

    String csv = const ListToCsvConverter().convert(linhas);
    print("IMPRIMINDO O CSV!!!!!");
    print(csv);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'relatorio.csv';
      html.document.body.children.add(anchor);

  // download
      anchor.click();

  // cleanup
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

    //final url = html.Url.createObjectUrlFromBlob(blob);


  }

  iniciarConversao( List<Corrida> corridas,
      int diaInicial,
      int diaFinal){
 this.corridas;
    this.diaInicial = diaInicial;
    this.diaFinal = diaFinal;

    gerarCsv();
  }


}