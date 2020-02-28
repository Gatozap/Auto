import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Notificacao.dart';
import 'package:bocaboca/Objetos/Pacote.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';

class CadastrarPacoteController extends BlocBase {
  BehaviorSubject<Pacote> _controllerPacote = new BehaviorSubject<Pacote>();
  Stream<Pacote> get outPacote => _controllerPacote.stream;

  Sink<Pacote> get inPacote => _controllerPacote.sink;
  Pacote produto;
  String lastcep;

  /*Future<Endereco> BuscarLatLng(Endereco e) async {
    final query =
        '${e.numero} ${e.endereco}, ${e.bairro},${e.cidade} - ${e.cep}';
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    e.lat = first.coordinates.latitude;
    e.lng = first.coordinates.longitude;
    return e;
  }*/

  /*Future FetchCep(String value) async {
    outProduto.first.then((e) async {
      produto = e;

      if (produto.localizacao.cep != lastcep) {
        lastcep = value;
        final response = await http.get(
            'http://viacep.com.br/ws/' + value.replaceAll('-', '') + '/json/');

        print('viacep.com.br/ws/' + value.replaceAll('-', '') + '/json/');

        if (response.statusCode == 200) {
          // If the call to the server was successful, parse the JSON

          Map r = json.decode(response.body);
          print('AQUI R ${r}');
          Endereco endereco = new Endereco(
            cidade: r['localidade'],
            cep: value,
            bairro: r['bairro'],
            endereco: r['logradouro'],
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
          );
          produto.localizacao = endereco;
          inEvento.add(produto);
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      }
    });
  }*/

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPacote.close();
  }

  Future CadastrarPacote(Pacote produto) async {
    if (produto.foto != null) {
      String fotoUrl = await Helper().uploadPicture(produto.foto);
      if (fotoUrl != null) {
        produto.foto = fotoUrl;
      }
    }
    return pacotesRef.add(produto.toJson()).then((v) {
      produto.id = v.documentID;
      return pacotesRef
          .document(v.documentID)
          .updateData(produto.toJson())
          .then((d) {
        print('cadastrado com sucesso');
        print('AQUI EVENTO ${produto.toString()}');
        sendNotificationPacote(produto);
        return produto;
      }).catchError((err) {
        print('Error: ${err}');
        return err;
      });
      ;
    }).catchError((err) {
      print('Error: ${err}');
      return err;
    });
  }
}

sendNotificationPacote(Pacote produto) async {
  String topic = 'Clientes${Helper.localUser.prestador}';

  topic = Helper.localUser
      .prestador; //DESCOMENTAR ESSA LINHA PRA MANDAR AS PUSHS PARA OS COACHS EM VEZ DOS CLIENTES

  print('INICIANDO NOTIFICAÇÃO');
  Notificacao n = new Notificacao(
      title: '${produto.titulo} Está a venda!',
      message: '',
      behaivior: 6,
      sended_at: DateTime.now(),
      sender: Helper.localUser.prestador,
      topic: topic,
      data: json.encode({
        'user': Helper.localUser.toJson(),
        'title': '${produto.titulo} Está a venda!',
        'message': '',
        'produto': produto.toJson(),
        'behaivior': 6,
        'sended_at': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': Helper.localUser.id,
        'topic': topic,
      }));
  n.image =
      produto.foto == null ? null : produto.foto != null ? produto.foto : null;

  http.post(notificationUrl, body: n.toJson()).then((v) {
    print('NOTIFICOU');
    print(v.body);
  }).catchError((e) {
    print('Err:' + e.toString());
  });
}
