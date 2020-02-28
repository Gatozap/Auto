import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Telas/Cadastro/CadastroPage.dart';
import 'package:autooh/Telas/Home/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../main.dart';
import 'LoginController.dart';
import 'LoginEmail/CadastroEmail/cadastroemail.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController lc = new LoginController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProgressDialog pr;
  void showLoading(context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
  }

  var controllerEmail = new TextEditingController();

  var controllerSenha = new TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool logedIn = false;
  @override
  Widget build(BuildContext context) {
    double margem = MediaQuery.of(context).size.height * .03;
    double labelsSize = MediaQuery.of(context).size.width * .035;
    final registerLabel = FlatButton(
      splashColor: Colors.black,
      child: Text(
        'Cadastre-se',
        style: TextStyle(color: Colors.black, fontSize: labelsSize),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CadastroEmail()));
      },
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Esqueceu a senha?',
        style: TextStyle(color: Colors.black, fontSize: labelsSize),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/esqueceusenha');
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                /*image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/bg_login.png'),
              ),*/
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 40.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    SizedBox(
                      height: margem,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      height: MediaQuery.of(context).size.height * .12,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * .3,
                        height: MediaQuery.of(context).size.height * .12,
                        color: Colors.transparent,
                        child: Image(
                          image: AssetImage('assets/images/nutrannoLogo.png'),
                          width: MediaQuery.of(context).size.width * .7,
                          height: MediaQuery.of(context).size.height * .7,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: margem,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: controllerEmail,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        suffixIcon: Icon(
                          LineAwesomeIcons.envelope,
                          color: corPrimaria,
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: margem,
                    ),
                    TextFormField(
                      controller: controllerSenha,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        suffixIcon: Icon(
                          LineAwesomeIcons.key,
                          color: corPrimaria,
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: margem,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        color: corPrimaria,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          showLoading(context);
                          lc.LoginEmail(
                                  email: controllerEmail.text,
                                  password: controllerSenha.text)
                              .then((v) {
                            if (pr.isShowing()) {
                              pr.dismiss();
                            }
                            if (v) {
                              pushHome(context);
                            } else {
                              dToast(
                                  'Erro ao efetuar Login. Você já é cadastrado(a)?');
                            }
                          }).catchError((err) {
                            if (pr.isShowing()) {
                              pr.dismiss();
                            }
                          });
                        },
                        padding: EdgeInsets.all(5),
                        child: Text('Entrar', style: estiloTextoBotao),
                      ),
                    ),
                    SizedBox(
                      height: margem,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        forgotLabel,
                        registerLabel,
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                          child: (Image(
                            image: AssetImage(
                              "assets/facebook_logo.png",
                            ),
                            height: 40.0,
                            width: 40.0,
                          )),
                          onPressed: () {
                            showLoading(context);
                            lc.LoginFacebook().then((r) {
                              if (r == 0) {
                                if (pr.isShowing()) {
                                  pr.dismiss();
                                }
                                pushHome(context);
                              } else {
                                if (pr.isShowing()) {
                                  pr.dismiss();
                                }
                                print(r.toString());
                              }
                            }).catchError((onError) {
                              if (pr.isShowing()) {
                                pr.dismiss();
                              }
                              print('ERRO ${onError.toString()}');
                            });
                          },
                        ),
                        CupertinoButton(
                          child: (Image(
                            image: AssetImage(
                              "graphics/google-logo.png",
                              package: "flutter_auth_buttons",
                            ),
                            height: 40.0,
                            width: 40.0,
                          )),
                          onPressed: () {
                            showLoading(context);
                            lc.LoginGoogle().then((r) {
                              if (r == 0) {
                                if (pr.isShowing()) {
                                  pr.dismiss();
                                }
                                pushHome(context);
                              } else {
                                if (pr.isShowing()) {
                                  pr.dismiss();
                                }
                                print(r.toString());
                              }
                            }).catchError((onError) {
                              if (pr.isShowing()) {
                                pr.dismiss();
                              }
                              print('Erro: ${onError.toString()}');
                            });
                          },
                        ),
                        isIOS
                            ? CupertinoButton(
                                child: (Image(
                                  image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/152px-Apple_logo_black.svg.png'),
                                  height: 40.0,
                                  width: 40.0,
                                )),
                                onPressed: () {
                                  showLoading(context);
                                  lc.logInApple().then((r) {
                                    if (r == 0) {
                                      print('CHEGOU AQUI RETORNOU 0');
                                      if (pr.isShowing()) {
                                        pr.dismiss();
                                      }
                                      pushHome(context);
                                    } else {
                                      if (pr.isShowing()) {
                                        pr.dismiss();
                                      }
                                      print(r.toString());
                                    }
                                  }).catchError((onError) {
                                    print('CHEGOU AQUI RETORNOU ERRO ${onError.toString()}');
                                    if (pr.isShowing()) {
                                      pr.dismiss();
                                    }
                                    print('Erro: ${onError.toString()}');
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: margem,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onError(err) {
    print('Error: ${err.toString()}');
  }

  pushHome(context) {
    logedIn = true;
    if (pr.isShowing()) {
      pr.dismiss();
    }
    if (Helper.localUser.isPrestador == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>Cadastro()));
    } else {
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
    }
  }
}