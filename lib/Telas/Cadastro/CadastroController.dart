import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Telas/Grupo/Chat/ChatScreen/ChatController.dart';
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

  BehaviorSubject<String> controllerCodigo = BehaviorSubject<String>();
  Stream<String> get outCodigo => controllerCodigo.stream;
  Sink<String> get inCodigo => controllerCodigo.sink;
  String codigo;

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

  BehaviorSubject<Documento> controllerDocumento  = BehaviorSubject<Documento>();
  Stream<Documento> get outDocumento => controllerDocumento.stream;
  Sink<Documento> get inDocumento => controllerDocumento.sink;
  Documento documento;

  CadastroController() {
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
      Endereco endereco, int behaviour) {
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
          Helper.localUser.genero = isMale ? 'Masculino' : 'Feminino';
          Helper.localUser.celular = telefone;
          Helper.localUser.prestador = codigo;
          Helper.localUser.cpf = CPF;
          Helper.localUser.endereco = endereco;
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
          Helper.localUser.data_nascimento = DateTime.utc(
              int.parse(datanascimento.split('/')[2]),
              int.parse(datanascimento.split('/')[1]),
              int.parse(datanascimento.split('/')[0]));
          print("AQUI LENGTH ${'99-9999999'.length} e ${codigo.length}");
          print(
              'AQUI DATA NASICMENTO ${Helper.localUser.data_nascimento.toIso8601String()}');

          if (DateTime.now().year - Helper.localUser.data_nascimento.year <
                  12 ||
              DateTime.now().year - Helper.localUser.data_nascimento.year >
                  120) {
            if (DateTime.now().year - Helper.localUser.data_nascimento.year <
                12) {
              print(
                  'AQUI IDADE DEMONIO ${Helper.localUser.data_nascimento.year - DateTime.now().year}');
              dToastTop(
                  'Infelizmente você não tem a idade minima(12) para participar do autooh =/');
              return;
            }
            if (DateTime.now().year - Helper.localUser.data_nascimento.year >
                120) {
              print(
                  'AQUI IDADE DEMONIO ${Helper.localUser.data_nascimento.year - DateTime.now().year}');
              dToastTop('Data de Nascimento Invalida');
            }
            return;
          } else {
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
                      if (behaviour == 0) {
                        print(Helper.localUser.endereco);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => CadastrarEstabelecimentoPage(
                                estabelecimento: codigo)));
                      }

                      if (behaviour == 1) {
                        print('ESTROU AQUI DEMONIO');
                        print(Helper.localUser.endereco);
                        Prestador c = new Prestador(
                          updated_at: DateTime.now(),
                          created_at: DateTime.now(),
                          telefone: telefone,
                          endereco: endereco,
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
