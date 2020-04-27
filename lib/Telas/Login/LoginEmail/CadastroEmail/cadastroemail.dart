import 'package:autooh/Telas/Cadastro/CadastroController.dart';
import 'package:autooh/Telas/Cadastro/CadastroPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Login/LoginController.dart';
import 'package:autooh/Telas/Login/LoginEmail/CadastroEmail/cadastroemailController.dart';

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
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
        colors: <Color>[
          Color.fromRGBO(0, 168, 180, 100),
          Colors.indigo,
        ],
      ),
    );
    cec = new CadastroEmailController();
    return Scaffold(

        key: CadastroEmail.scaffoldKey,

         appBar: myAppBar('Cadastro', context, showBack: true),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: linearGradient,
              height: getAltura(context),
              width: getLargura(context),
              child: ListView(
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
                                width: MediaQuery.of(context).size.width * .5,
                                height: MediaQuery.of(context).size.height * .06,
                                decoration: BoxDecoration(
                                    color: Colors.yellowAccent,
                                    borderRadius: BorderRadiusDirectional.all(
                                        Radius.circular(60))),
                                child: Center(
                                    child: Text(
                                  'Criar Conta',
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
                                            color: Colors.yellowAccent, fontSize: 12)),
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
                                            color: Colors.yellowAccent, fontSize: 12))
                                  ]))
                            ],
                          ))),
                ],
              ),
            ),
          ],
        ));
  }

  buildUserForm(User data, CadastroEmailController cec) {
    return Form(
      key: _formKey,
      child: Column(

          children: <Widget>[
    

        Padding(padding: ei),
        Padding(
          padding:  EdgeInsets.only(right: 80.0, bottom: 5, top: 20),
          child: hText('Nome Completo', context, color: Colors.white70, size: 40, weight: FontWeight.bold),
        ),

        Row(
          children: <Widget>[
            Padding(        padding: EdgeInsets.only(left: 40, right: 10), child: Icon(LineAwesomeIcons.user, color: Colors.white70,),),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(right: 20),
                child: TextFormField(
                             cursorColor: Colors.black,
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
                    fillColor: Colors.cyan[600],
                    filled: true,
                      focusColor: Colors.white,
                           hintText: 'José da Silva',
                    hintStyle: TextStyle(color: Colors.white30),
                    contentPadding:
                    EdgeInsets.fromLTRB(20, 10.0, 20, 10.0),

                    enabledBorder: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),
                  ),
                ),
              ),
            ),
          ],
        ),
              sb,
            Padding(
              padding:  EdgeInsets.only(right: 140.0, bottom: 5),
              child: hText('E-mail', context, color: Colors.white70, size: 40, weight: FontWeight.bold),
            ),
        Row(
          children: <Widget>[
            Padding(        padding: EdgeInsets.only(left: 40, right: 10), child: Icon(LineAwesomeIcons.envelope, color: Colors.white70,),),

            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(right: 20),
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
                    fillColor: Colors.cyan[600],
                    filled: true,
                    focusColor: Colors.white,
                        hintText: 'contato@hotmail.com',
                    hintStyle: TextStyle(color: Colors.white30),
                    contentPadding:
                    EdgeInsets.fromLTRB(20, 10.0, 20, 10.0),

                    enabledBorder: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),
                  ),
                ),
              ),
            ),
          ],
        ),sb,

            Padding(
              padding:  EdgeInsets.only(right: 140.0, bottom: 5),
              child: hText('Senha', context, color: Colors.white70, size: 40, weight: FontWeight.bold),
            ),
        Row(
          children: <Widget>[
            Padding(        padding: EdgeInsets.only(left: 40, right: 10), child: Icon(LineAwesomeIcons.key, color: Colors.white70,),),

            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(right: 20),
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
                    fillColor: Colors.cyan[600],
                    filled: true,
                    focusColor: Colors.white,
                        hintText: 'XYJG546',
                    hintStyle: TextStyle(color: Colors.white30),
                    contentPadding:
                    EdgeInsets.fromLTRB(20, 10.0, 20, 10.0),

                    enabledBorder: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),
                  ),
                ),
              ),
            ),
          ],
        ),sb,
            Padding(
              padding:  EdgeInsets.only(right: 100.0, bottom: 5),
              child: hText('Repita a Senha', context, color: Colors.white70, size: 40, weight: FontWeight.bold),
            ),
        Row(
          children: <Widget>[
            Padding(        padding: EdgeInsets.only(left: 40, right: 10), child: Icon(LineAwesomeIcons.key, color: Colors.white70,),),

            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(right: 20),
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
                    fillColor: Colors.cyan[600],
                    filled: true,
                    focusColor: Colors.white,
                    hintText: 'XYJG546',
                    hintStyle: TextStyle(color: Colors.white30),
                    contentPadding:
                    EdgeInsets.fromLTRB(20, 10.0, 20, 10.0),

                    enabledBorder: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.cyan[600])),
                  ),
                ),
              ),
            ),
          ],
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
