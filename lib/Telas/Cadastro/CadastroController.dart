import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Telas/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swiper/src/swiper_controller.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Cadastro/Estabelecimento/CadastrarEstabelecimentoPage.dart';
import 'package:rxdart/rxdart.dart';

class CadastroController extends BlocBase {
  BehaviorSubject<bool> controllerIsPrestadorSelected = BehaviorSubject<bool>();
  Stream<bool> get outIsPrestadorSelected => controllerIsPrestadorSelected.stream;
  Sink<bool> get inIsPrestadorSelected => controllerIsPrestadorSelected.sink;

  BehaviorSubject<bool> controllerIsMale = BehaviorSubject<bool>();
  Stream<bool> get outIsMale => controllerIsMale.stream;
  Sink<bool> get inIsMale => controllerIsMale.sink;

  BehaviorSubject<bool> controllerIsAtendeFds = BehaviorSubject<bool>();
  Stream<bool> get outIsAtendefds => controllerIsAtendeFds.stream;
  Sink<bool> get inIsAtendefds => controllerIsAtendeFds.sink;

  BehaviorSubject<bool> controllerIsAtendeFesta = BehaviorSubject<bool>();
  Stream<bool> get outIsAtendeFest => controllerIsAtendeFesta.stream;
  Sink<bool> get inIsAtendeFest => controllerIsAtendeFesta.sink;

  BehaviorSubject<bool> controllerBanco = BehaviorSubject<bool>();
  Stream<bool> get outBanco => controllerBanco.stream;
  Sink<bool> get inBanco => controllerBanco.sink;

  BehaviorSubject<String> controllerCodigo = BehaviorSubject<String>();
  Stream<String> get outCodigo => controllerCodigo.stream;
  Sink<String> get inCodigo => controllerCodigo.sink;
  String codigo;

  BehaviorSubject<User> controllerUser = BehaviorSubject<User>();
  Stream<User> get outUser => controllerUser.stream;
  Sink<User> get inUser => controllerUser.sink;
  User user;

  BehaviorSubject<String> controllerCPF = BehaviorSubject<String>();
  Stream<String> get outCPF => controllerCPF.stream;
  Sink<String> get inCPF => controllerCPF.sink;
  String CPF;

  BehaviorSubject<String> controllerTelefone = BehaviorSubject<String>();
  Stream<String> get outTelefone => controllerTelefone.stream;
  Sink<String> get inTelefone => controllerTelefone.sink;
  String telefone;

  BehaviorSubject<String> controllerDatanascimento = BehaviorSubject<String>();
  Stream<String> get outDatanascimento => controllerDatanascimento.stream;
  Sink<String> get inDatanascimento => controllerDatanascimento.sink;
  String datanascimento;

  BehaviorSubject<String> controllerContabancaria = BehaviorSubject<String>();
  Stream<String> get outContaBancaria => controllerContabancaria.stream;
  Sink<String> get inContaBancaria => controllerContabancaria.sink;
  String conta_bancaria;


  BehaviorSubject<String> controllerAgencia = BehaviorSubject<String>();
  Stream<String> get outAgencia => controllerAgencia.stream;
  Sink<String> get inAgencia => controllerAgencia.sink;
  String agencia;


  BehaviorSubject<String> controllerNumeroConta = BehaviorSubject<String>();
  Stream<String> get outNumeroConta => controllerNumeroConta.stream;
  Sink<String> get inNumeroConta => controllerNumeroConta.sink;
  String numero_conta;

  BehaviorSubject<Documento> controllerDocumento  = BehaviorSubject<Documento>();
  Stream<Documento> get outDocumento => controllerDocumento.stream;
  Sink<Documento> get inDocumento => controllerDocumento.sink;
  Documento documento;

  BehaviorSubject<Carro> controllerCarro  = BehaviorSubject<Carro>();
  Stream<Carro> get outCarro => controllerCarro.stream;
  Sink<Carro> get inCarro => controllerCarro.sink;
  Carro carro;

  CadastroController({this.carro}) {

    inIsPrestadorSelected.add(false);
    inIsMale.add(false);
    telefone = '';
    inTelefone.add(telefone);
    codigo = '';
    inCodigo.add(codigo);
    datanascimento = '';
    inDatanascimento.add(datanascimento);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerDatanascimento.close();
    inIsPrestadorSelected.close();
    controllerTelefone.close();
    controllerCodigo.close();
    controllerIsMale.close();
    controllerCPF.close();
    controllerContabancaria.close();
    controllerAgencia.close();
    controllerNumeroConta.close();
    controllerCarro.close();
    controllerBanco.close();
  }

  Validar(int i, SwiperController sc, BuildContext context) async {
    switch (i) {
      case 1:
        break;
      case 2:
        break;
      case 4:
        if (telefone == '' || datanascimento == '') {
          dToast(
              'Por Favor Preencha ${telefone == '' ? 'o Telefone' : 'a Data de Nascimento'}');
        }
        break;
    }
  }



  void updateCodigo(String barcode) {
    codigo = barcode;
    inCodigo.add(codigo);
  }

  void updateTelefone(String tel) {
    telefone = tel;
    inTelefone.add(telefone);
  }

  void updateDataNascimento(String data) {
    datanascimento = data;
    inDatanascimento.add(datanascimento);
  }

  void atualizarDados(SwiperController sc, BuildContext context,
   int behaviour) {
    outIsPrestadorSelected.first.then((isPrestador) {
      outIsMale.first.then((isMale) async {
        if (isPrestador != null || isMale || null) {
          if (codigo == null) {
            sc.move(2);
            dToast('Por Favor Preencha o codigo do prestador');
            return;
          }
          if (telefone == '' || datanascimento == '') {
            dToast(
                'Por Favor Preencha ${telefone == '' ? 'o Telefone' : 'a Data de Nascimento'}');
            return;
          }
          Helper.localUser.isPrestador = isPrestador;

          Helper.localUser.celular = telefone;
          Helper.localUser.prestador = codigo;
          Helper.localUser.cpf = CPF;



          if(carro != null){
            if(Helper.localUser.carros == null){
              Helper.localUser.carros = new List<Carro>();
            }
            carro.created_at = DateTime.now();
            carro.updated_at = DateTime.now();
            Helper.localUser.carros.add(carro);
          }
          if(documento != null){
            if(Helper.localUser.documentos ==null){
              Helper.localUser.documentos = new List<Documento>();
            }
            documento.created_at = DateTime.now();
            documento.updated_at = DateTime.now();
            if(!documento.isValid){
              dToast('Foto do documento Invalida por favor tente tirar a foto novamente');
              return;
            }
            Helper.localUser.documentos.add(documento);
          }
            if (isPrestador) {
              userRef
                  .where('prestador', isEqualTo: codigo)
                  .where('isPrestador', isEqualTo: true)
                  .getDocuments()
                  .then((v) async {
                if (v.documents.isEmpty) {
                      print('Administrador Criado Com Sucesso!');
                      Helper.localUser.isEmpresario = true;
                      userRef
                          .document(Helper.localUser.id)
                          .updateData(Helper.localUser.toJson());

                      print('CHEGOU AQUI BEHAVIOR ${behaviour}');


                      if (behaviour == 1) {


                        Prestador c = new Prestador(
                          updated_at: DateTime.now(),
                          created_at: DateTime.now(),
                          telefone: telefone,

                          isHerbalife: true,
                          usuario: Helper.localUser.id,
                          nome: Helper.localUser.nome,
                          email: Helper.localUser.email,
                          cpf: await outCPF.first,
                          numero: codigo,
                        );
                        print('AQUI');
                            await EnviarPush();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage()));
                      }
                } else {
                  Helper.localUser.isEmpresario = false;
                  userRef
                      .document(Helper.localUser.id)
                      .updateData(Helper.localUser.toJson());
                  await EnviarPush();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()));
                }
              });
            } else {
              Helper.localUser.isEmpresario = false;
              userRef
                  .document(Helper.localUser.id)
                  .updateData(Helper.localUser.toJson());
              await EnviarPush();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()));
            }
        } else {
          sc.move(isPrestador == null ? 0 : 1);
          dToast('Por Favor Preencha Selecione uma das opções');
        }
      }).catchError(onError);
    }).catchError(onError);
  }

  onError(err) {
    print('CadastroControllerr Error: ${err.toString()}');
  }

  void updateCPF(String cpf) {
    CPF = cpf;
    inCPF.add(CPF);
  }
  void updateBanco(String banco) {
    conta_bancaria = banco;
    inContaBancaria.add(conta_bancaria);
  }

  void updateNumeroConta(String numero) {
    numero_conta = numero;
    inNumeroConta.add(numero_conta);
  }

  void updateAgencia(String agencias) {
    agencia = agencias;
    inAgencia.add(agencia);
  }



  Future EnviarPush() {
    /*print('Enviando Push');
    return userRef.document('G0vWxZXtRbYCQzqPI7BEkZYSfx12').get().then((v) {
      User u = User.fromJson(v.data);
      ChatController cc = new ChatController(u, true, null, null);
      return Future.delayed(Duration(seconds: 3)).then((v) {
        cc.sendMessage(
            text:
                '${Helper.localUser.nome}, Acaba de entrar pela primeira vez');
        print('ENVIOU MENSAGEM ');
        return;
      });
    });*/
  }
}
