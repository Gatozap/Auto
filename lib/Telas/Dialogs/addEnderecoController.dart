import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:rxdart/rxdart.dart';

class AddEnderecoController implements BlocBase {
  final userRef = Firestore.instance.collection('Users').reference();
  final coachsRef = Firestore.instance.collection('Coachs').reference();
  BehaviorSubject<Endereco> _controllerEndereco =
      new BehaviorSubject<Endereco>();
  Stream<Endereco> get outEndereco => _controllerEndereco.stream;

  Sink<Endereco> get inEndereco => _controllerEndereco.sink;
  String cep = "";
  Fetch() {}
  Future FetchCep(String value) async {
    if (cep != value) {
      final response = await http.get(
          'http://viacep.com.br/ws/' + value.replaceAll('-', '') + '/json/');

      print('viacep.com.br/ws/' + value.replaceAll('-', '') + '/json/');

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON

        Map r = json.decode(response.body);
        print('AQUI R ${r}');
        if (r['erro'] == true) {
          dToast('Erro Ao Buscar Cep');
        }else{
        inEndereco.add(new Endereco(
          cidade: r['localidade'],
          cep: value,
          estado: r['uf'],
          bairro: r['bairro'],
          endereco: r['logradouro'],
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
        ));}

      } else {
        // If that call was not successful, throw an error.
        dToast('Erro Ao Buscar Cep');
        throw Exception('Failed to load post');
      }
      cep = value;
    }
  }

  @override
  void dispose() {
    _controllerEndereco.close();
  }

    AddEnderecoController(Endereco ue) {
      inEndereco.add(ue);
  }

  Future Cadastrar(String numero) async {
    Endereco e = await outEndereco.first;
    e.numero = numero;
    print('INICIANDO ${e.toString()}');
    if (e != null) {
      if (e.lat == null && e.lng == null) {
        e = await BuscarLatLng(e);
      }
      Helper.localUser.endereco = e;

      return userRef
          .document(Helper.localUser.id)
          .updateData(Helper.localUser.toJson())
          .then((v) {
        print('CHEGOU AQUI ${Helper.localUser.endereco}');
        return true;
      }).catchError((err) {
        print('Error: ${err.toString()}');
        return false;
      });
    }
  }

  Future<Endereco> BuscarLatLng(Endereco e) async {
    try {
      final query =
          '${e.numero} ${e.endereco}, ${e.bairro},${e.cidade} - ${e.cep}';
      print('QUERY LAT LNG ${query}');
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      print("${first.featureName} : ${first.coordinates}");
      e.lat = first.coordinates.latitude;
      e.lng = first.coordinates.longitude;
      print('Retornnando ${e.toString()}');
      return e;
    }catch(err){
      print('erro: ${err.toString()}');
      return e;
    }
  }

  Future CadastrarCoach(String numero, Prestador prestador) async {
    print('ENTROU AQUI');
    Endereco e = await outEndereco.first;
    e.numero = numero;
    if (e != null) {
      if (e.lat == null && e.lng == null) {
        e = await BuscarLatLng(e);
      }
      prestador.endereco = e;

      return prestadorRef
          .document(prestador.numero)
          .updateData(prestador.toJson())
          .then((v) {
        return true;
      }).catchError((err) {
        print('Error: ${err.toString()}');
        return false;
      });
    }
  }
}
