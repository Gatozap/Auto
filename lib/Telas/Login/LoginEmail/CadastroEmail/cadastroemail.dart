import 'package:bocaboca/Telas/Cadastro/CadastroController.dart';
import 'package:bocaboca/Telas/Cadastro/CadastroPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:bocaboca/Telas/Login/LoginController.dart';
import 'package:bocaboca/Telas/Login/LoginEmail/CadastroEmail/cadastroemailController.dart';

import '../../PoliticaPage.dart';
import '../../TermosPage.dart';
import 'cadastroemailController.dart';

class CadastroEmail extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _CadastroEmailState createState() => _CadastroEmailState();
}

class _CadastroEmailState extends State<CadastroEmail> {
  CadastroEmailController cec;
  bool isLogedIn = false;

  final _formKey = GlobalKey<FormState>();

  Color pageColor = corPrimaria;

  var controllerEmail = TextEditingController();
  var controllercpf =
      new MaskedTextController(text: '', mask: '000.000.000-00');

  var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');

  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');

  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');

  var controllerSenha = new TextEditingController(text: '');

  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);

  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');

  var controllerCidade = new TextEditingController(text: '');

  var controllerEstado = new TextEditingController(text: '');

  var controllerEndereco = new TextEditingController(text: '');

  var controllerBairro = new TextEditingController(text: '');

  CadastroController cc = new CadastroController();

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    cec = new CadastroEmailController();
    return Scaffold(
        key: CadastroEmail.scaffoldKey,
        drawer: CustomDrawerWidget(),
        appBar: myAppBar('Cadastro', context, showBack: true),
        body: ListView(
          children: <Widget>[
            buildUserForm(User.Empty(), cec),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            MaterialButton(
                onPressed: () {
                  dToast('Cadastrando...');

                  setState(() {
                    isPressed = true;
                  });
                  if (_formKey.currentState.validate()) {
                    print('Entrou AQUI');
                    cec.outUser.first.then((u) {
                      print(u.toString());
                      cec.registerUser(u).then((value) {
                        if (value == 0) {
                          dToast('Cadastrado com sucesso!');

                          Future.delayed(Duration(seconds: 2)).then((v) {
                            LoginController lc = LoginController();
                            lc.LoginEmail(
                                    email: controllerEmail.text,
                                    password: controllerSenha.text)
                                .then((v) {
                              if (v) {
                                pushHome(context);
                              } else {
                                dToast(
                                    'Erro ao efetuar Login. Você já é cadastrado(a)?');
                              }
                            }).catchError((err) {});
                          });
                        } else if (value == 1) {
                          dToast(
                              'Erro ao efetuar cadastro: Telefone já cadastrado!');
                        } else {

                        }
                      });
                    });
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                              color: corPrimaria,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(60))),
                          child: Center(
                              child: Text(
                            'Cadastrar',
                            style: estiloTextoBotao,
                          )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Text.rich(TextSpan(
                            text:
                                'Ao clicar em cadastrar, você concorda com nossos ',
                            style: estiloTextoRodape,
                            children: [
                              TextSpan(
                                  text: 'Termos de Uso',
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TermosPage()));
                                    },
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12)),
                              TextSpan(
                                  text: ' e ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                              TextSpan(
                                  text: 'Política de Privacidade',
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PoliticaPage()));
                                    },
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12))
                            ]))
                      ],
                    ))),
          ],
        ));
  }

  buildUserForm(User data, CadastroEmailController cec) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Padding(padding: ei),
        new Padding(
          padding: ei,
          child: TextFormField(
            autovalidate: true,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (isPressed) {
                if (value.isEmpty) {
                  return 'É necessário preencher o Nome';
                } else {
                  data.nome = value;
                  cec.inUser.add(data);
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  LineAwesomeIcons.user,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                hintText: 'João da Silva',
                labelText: 'Nome Completo',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: corPrimaria,
                    fontStyle: FontStyle.italic)),
          ),
        ),
        new Padding(
          padding: ei,
          child: TextFormField(
            controller: controllerEmail,
            keyboardType: TextInputType.emailAddress,
            autovalidate: true,
            validator: (value) {
              if (isPressed) {
                if (value.isEmpty) {
                  return 'É necessário preencher o E-mail';
                } else {
                  if (value.contains('@')) {
                    data.email = value;
                    cec.inUser.add(data);
                  } else {
                    return 'E-mail inválido!';
                  }
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  LineAwesomeIcons.envelope,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                hintText: 'contato@hotmail.net',
                labelText: 'E-mail',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: corPrimaria,
                    fontStyle: FontStyle.italic)),
          ),
        ),
        /*new Padding(
          padding: ei,
          child: TextFormField(
            controller: controllerDataNascimento,
            keyboardType: TextInputType.number,
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'É necessário preencher a Data de Nascimento';
              } else {
                if (value.length != '00/00/0000'.length) {
                  return 'Data de Nascimento Invalida!';
                } else {
                  var s = value.split('/');
                  data.data_nascimento = new DateTime(
                      int.parse(s[2]), int.parse(s[1]), int.parse(s[0]));
                  print('Data Nascimento ' +
                      data.data_nascimento.toIso8601String());
                  cec.inUser.add(data);
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  Icons.date_range,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                labelText: 'Data de Nascimento',
                hintText: 'dd/mm/aaaa',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic)),
          ),
        ),*/
        /*new Padding(
          padding: ei,
          child: TextFormField(
            autovalidate: true,
            controller: controllercpf,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'É necessário preencher o CPF';
              } else {
                if (value.length != '000.000.000-00'.length) {
                  return 'CPF Invalido';
                } else {
                  data.cpf = value;
                  cec.inUser.add(data);
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                labelText: 'CPF',
                hintText: '000.000.000-00',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic)),
          ),
        ),*/

        new Padding(
          padding: ei,
          child: TextFormField(
            autovalidate: true,
            controller: controllerSenha,
            obscureText: true,
            validator: (value) {
              if (isPressed) {
                if (value.isEmpty) {
                  return 'É necessário preencher a Senha';
                } else {
                  if (value.length < 6) {
                    return 'Senha é muito curta!';
                  } else {
                    var s = value.split('/');
                  }
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  LineAwesomeIcons.key,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                hintText: 'Xylophone1234',
                labelText: 'Senha',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: corPrimaria,
                    fontStyle: FontStyle.italic)),
          ),
        ),

        new Padding(
          padding: ei,
          child: TextFormField(
            autovalidate: true,
            obscureText: true,
            validator: (value) {
              if (isPressed) {
                if (value.isEmpty) {
                  return 'É necessário preencher a Senha';
                } else {
                  if (value.length < 6) {
                    return 'Senha é muito curta!';
                  } else {
                    if (value == controllerSenha.text) {
                      data.senha = value;
                      cec.inUser.add(data);
                    } else {
                      return 'Senhas não conferem';
                    }
                  }
                }
              }
            },
            decoration: InputDecoration(
                icon: Icon(
                  LineAwesomeIcons.key,
                  color: pageColor,
                ),
                /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid)),*/
                hintText: 'Xylophone1234',
                labelText: 'Repita a Senha',
                hintStyle: TextStyle(
                    color: corPrimaria,
                    fontSize: 14.0,
                    fontStyle: FontStyle.italic)),
          ),
        ),
      ]),
    );
  }

  pushHome(context) {
    isLogedIn = true;

    if (Helper.localUser.grupo != '' && Helper.localUser.grupo != 'Nenhum') {
      if (Helper.localUser.isEmpresario) {
        Helper.fbmsg.subscribeToTopic('Empresario' + Helper.localUser.grupo);
      }
      if (Helper.localUser.isPrestador) {
        Helper.fbmsg.subscribeToTopic('Prestador' + Helper.localUser.grupo);
      }
      Helper.fbmsg.subscribeToTopic('User' + Helper.localUser.grupo);
      Helper.fbmsg.subscribeToTopic('Grupo' + Helper.localUser.grupo);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Cadastro()));
  }
}
