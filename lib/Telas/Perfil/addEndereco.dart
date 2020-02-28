import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


import '../../main.dart';
import 'addEnderecoController.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


import '../../main.dart';
import 'addEnderecoController.dart';

class AddEndereco extends StatefulWidget {
  Endereco ue;

  AddEndereco(this.ue);

  @override
  _AddEnderecoState createState() {
    return _AddEnderecoState(ue);
  }
}

class _AddEnderecoState extends State<AddEndereco> {
  var controller = new MaskedTextController(mask: '000', text: '1');
  Endereco ue;


  _AddEnderecoState(this.ue);

  AddEnderecoController aec;

  @override
  Widget build(BuildContext context) {
    if (aec == null) {
      aec = new AddEnderecoController(ue);
    }
    return Scaffold(
        appBar: myAppBar('Editar Endereço', context, showBack: true),
        body: SSB(
            stream: aec.outEndereco,
            buildfunction: (BuildContext context, snapshot) {
              if (snapshot.data != null) {
                print('${snapshot.data.toString()} aqui é o null q da erro');
                return Container(
                  child: buildEnderecoForm(
                      snapshot.data,
                      aec,
                      context),
                  );
              } else {
                print('${snapshot.data.toString()} aqui é o null q da erro');
                return Container();
              }
            }));
  }

  bool isCadastrarPressed = false;
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
  var controllerNumero = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode;

  buildEnderecoForm(
      Endereco ue, AddEnderecoController cufc, BuildContext context) {
    myFocusNode = FocusNode();
    if (ue == null) {
      ue = new Endereco.Empty();
    }
    controllerCEP.text = ue.cep != null ? ue.cep : '';
    controllerCidade.text = ue.cidade != null ? ue.cidade : '';
    controllerEndereco.text = ue.endereco != null ? ue.endereco : '';
    controllerBairro.text = ue.bairro != null ? ue.bairro : '';
    controllerNumero.text = ue.numero != null ? ue.numero : '';
    controllerComplemento.text = ue.complemento != null ? ue.complemento : '';
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: ei,
                child: Divider(
                  color: Colors.black,
                  height: 5.0,
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  //onFieldSubmitted: cufc.FetchCep,
                  controller: controllerCEP,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value.isEmpty) {
                      if (isCadastrarPressed) {
                        return 'É necessário preencher o CEP';
                      }
                    } else {
                      if (value.length != 9) {
                        if (isCadastrarPressed) {
                          return 'CEP inválido';
                        }
                      } else {
                        if (value.length == 9) {
                          if (ue.cep != value) {
                            cufc.FetchCep(value);
                            //ue.cep = value;
                            //cufc.inEndereco.add(ue);
                            FocusScope.of(context).requestFocus(myFocusNode);
                          }
                        }
                      }
                    }
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.assistant_photo,
                    hintText: '00000-000',
                    labelText: 'CEP',
                    ),
                  autovalidate: true,
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerCidade,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher a Cidade';
                    } else {
                      ue.cidade = value;
                      cufc.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration( context,
                    icon: Icons.location_city,
                    hintText: 'São Paulo',
                    labelText: 'Cidade',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerBairro,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Bairro';
                    } else {
                      ue.bairro = value;
                      cufc.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.home,
                    hintText: 'Centro',
                    labelText: 'Bairro',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerEndereco,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Endereço';
                    } else {
                      ue.endereco = value;
                      cufc.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.add_location,
                    hintText: 'Rua da Saúde',
                    labelText: 'Endereço',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerNumero,
                  focusNode: myFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Número';
                    } else {
                      ue.numero = value;
                      cufc.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration( context,
                    icon: Icons.filter_1,
                    hintText: '3001',
                    labelText: 'Número',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerComplemento,
                  validator: (value) {
                    ue.complemento = value;
                    cufc.inEndereco.add(ue);
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.help,
                    hintText: 'Apto. 163',
                    labelText: 'Complemento',
                    ),
                  ),
                ),
              sb,
              MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      aec.Cadastrar(controllerNumero.text);
                    } else {
                      aec.Cadastrar(controllerNumero.text);
                    }

                      Navigator.of(context).pop();
                      //TODO CADASTRAR OS DADOS NO SERVIDOR
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
                                  'Salvar Endereço',
                                  style: estiloTextoBotao,
                                  )),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          Text(
                            'Antes de atualizar, verifique se todos os campos estão preenchidos corretamente!',
                            style: estiloTextoRodape,
                            ),
                        ],
                        )))
            ])));
  }
}

class EnderecoWidget{
  var controller = new MaskedTextController(mask: '000', text: '1');
  Endereco ue;



  EnderecoWidget(this.ue);

  bool isCadastrarPressed = false;
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
  var controllerNumero = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode;

  buildEnderecoForm(
      Endereco ue, AddEnderecoController aec, BuildContext context) {
    if(myFocusNode == null){
      myFocusNode = FocusNode();
    }

    if (ue == null) {
      ue = new Endereco.Empty();
    }
    if(controllerCEP.text.isEmpty) {
      controllerCEP.text = ue.cep != null ? ue.cep : '';
    }
    if(controllerCidade.text.isEmpty) {
      controllerCidade.text = ue.cidade != null ? ue.cidade : '';
    }
    if(controllerEndereco.text.isEmpty) {
      controllerEndereco.text = ue.endereco != null ? ue.endereco : '';
    }
    if(controllerBairro.text.isEmpty) {
      controllerBairro.text = ue.bairro != null ? ue.bairro : '';
    }
    if(controllerNumero.text.isEmpty) {
      controllerNumero.text = ue.numero != null ? ue.numero : '';
    }
    if(controllerComplemento.text.isEmpty) {
      controllerComplemento.text = ue.complemento != null ? ue.complemento : '';
    }
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: ei,
                child: Divider(
                  color: Colors.black,
                  height: 5.0,
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  onFieldSubmitted: aec.FetchCep,
                  controller: controllerCEP,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value.isEmpty) {
                      if (isCadastrarPressed) {
                        return 'É necessário preencher o CEP';
                      }
                    } else {
                      if (value.length != 9) {
                        if (isCadastrarPressed) {
                          return 'CEP inválido';
                        }
                      } else {
                        if (value.length == 9) {
                          if (ue.cep != value) {
                            aec.FetchCep(value);
                            ue.cep = value;
                            aec.inEndereco.add(ue);
                            FocusScope.of(context).requestFocus(myFocusNode);
                          }
                        }
                      }
                    }
                  },
                  decoration: DefaultInputDecoration( context,
                    icon: Icons.assistant_photo,
                    hintText: '00000-000',
                    labelText: 'CEP',
                    ),
                  autovalidate: true,
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerCidade,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher a Cidade';
                    } else {
                      ue.cidade = value;
                      aec.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.location_city,
                    hintText: 'São Paulo',
                    labelText: 'Cidade',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerBairro,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Bairro';
                    } else {
                      ue.bairro = value;
                      aec.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.home,
                    hintText: 'Centro',
                    labelText: 'Bairro',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerEndereco,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Endereço';
                    } else {
                      ue.endereco = value;
                      aec.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(
                    context,
                    icon: Icons.add_location,
                    hintText: 'Rua da Saúde',
                    labelText: 'Endereço',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerNumero,
                  focusNode: myFocusNode,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'É necessário preencher o Número';
                    } else {
                      ue.numero = value;
                      aec.inEndereco.add(ue);
                    }
                  },
                  decoration: DefaultInputDecoration(
                    context,
                    icon: Icons.filter_1,
                    hintText: '3001',
                    labelText: 'Número',
                    ),
                  ),
                ),
              new Padding(
                padding: ei,
                child: TextFormField(
                  controller: controllerComplemento,
                  validator: (value) {
                    ue.complemento = value;
                    aec.inEndereco.add(ue);
                  },
                  decoration: DefaultInputDecoration(context,
                    icon: Icons.help,
                    hintText: 'Apto. 163',
                    labelText: 'Complemento',
                    ),
                  ),
                ),
              sb,
              MaterialButton(
                  onPressed: () {
                    isCadastrarPressed = true;
                    if (_formKey.currentState.validate()) {

                      //myFocusNode.dispose();

                      Navigator.of(context).pop();
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
                                  'Salvar Endereço',
                                  style: estiloTextoBotao,
                                  )),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          Text(
                            'Antes de atualizar, verifique se todos os campos estão preenchidos corretamente!',
                            style: estiloTextoRodape,
                            ),
                        ],
                        )))
            ])));
  }
}
