import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:bocaboca/Helpers/DateSelector.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Despesa.dart';

import '../../../main.dart';

class CadastrarDespesaPage extends StatefulWidget {
  @override
  _CadastrarDespesaPageState createState() {
    return _CadastrarDespesaPageState();
  }
}

class _CadastrarDespesaPageState extends State<CadastrarDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  var controllerValor = new TextEditingController(text: '');
  var controllerDescricao = TextEditingController(text: '');
  bool isCadastrarPressed = false;
  bool repetivel = false;
  int tipo = 3;
  var dateSelector = BasicDateTimeField(
    label: 'Data de pagamento',
    icon: LineAwesomeIcons.calendar_minus_o,
    enable: true,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
        'Nova Despesa',
        context,
        showBack: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  sb,
                  DefaultField(
                      controller: controllerDescricao,
                      hint: 'Conta de luz',
                      context:context,
                      label: 'Descrição',
                      icon: FontAwesomeIcons.adn,
                      validator: (v) {},
                      keyboardType: TextInputType.text,
                      capitalization: TextCapitalization.words,
                      onSubmited: (s) {}),
                  DefaultField(
                      controller: controllerValor,
                      hint: 'R\$50,00',
                      label: 'Valor',
                      context:context,
                      enabled: true,
                      icon: FontAwesomeIcons.cashRegister,
                      capitalization: TextCapitalization.none,
                      validator: (v) {
                        if (isCadastrarPressed) {
                          try {
                            if (v.isEmpty ||
                                double.parse(v
                                            .replaceAll(',', '.')
                                            .replaceAll('cm', '')
                                            .replaceAll('c', '')
                                            .replaceAll('m', '')) ==
                                        0 &&
                                    isCadastrarPressed) {
                              return 'É necessário preencher o Valor';
                            } else {}
                          } catch (err) {
                            print(err.toString());
                            return 'Erro: Formato numérico inválido!';
                          }
                        }
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSubmited: (s) {}),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dateSelector,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: DropdownButton<int>(
                      hint: hText('Tipo da despesa',context),
                      value: tipo,
                      icon: Icon(
                        LineAwesomeIcons.calendar_times_o,
                        color: corPrimaria,
                      ),
                      onChanged: (int b) {
                        setState(() {
                          tipo = b;
                        });
                      },
                      items: [0, 1, 2, 3].map((int b) {
                        String tipo;
                        switch (b) {
                          case 0:
                            tipo = 'Diário';
                            break;
                          case 1:
                            tipo = 'Mensal';
                            break;
                          case 2:
                            tipo = 'Anual';
                            break;
                          case 3:
                            tipo = 'Único';
                            break;
                        }
                        return DropdownMenuItem<int>(
                          child: Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: hText(tipo,context)),
                          value: b,
                        );
                      }).toList(),
                    ),
                  ),
                  MaterialButton(
                      onPressed: () {
                        isCadastrarPressed = true;
                        if (_formKey.currentState.validate()) {
                          dToast(
                              'Cadastrando despesa. Isso pode levar algum tempo');
                          try {
                            if (dateSelector.Validate()) {
                              double valor = double.parse(controllerValor.text);
                              Despesa d = Despesa(
                                  updated_at: DateTime.now(),
                                  created_at: DateTime.now(),
                                  prestador: Helper.localUser.prestador,
                                  criador: Helper.localUser.id,
                                  data_pagamento: dateSelector.selectedDate,
                                  valor: valor,
                                  tipo: tipo,
                                  repetivel: tipo != 4,
                                  descricao: controllerDescricao.text);
                              despesasRef.add(d.toJson()).then((v) {
                                dToast('Despesa adicionada com sucesso!');
                                Navigator.of(context).pop();
                              });
                            } else {
                              dToast('Data selecionada é inválida');
                            }
                          } catch (err) {
                            print('ERROR: ${err.toString()}');
                            dToast('Erro no Valor');
                          }
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
                                height:
                                    MediaQuery.of(context).size.height * .08,
                                decoration: BoxDecoration(
                                    color: corPrimaria,
                                    borderRadius: BorderRadiusDirectional.all(
                                        Radius.circular(60))),
                                child: Center(
                                    child: Text(
                                  'Cadastrar Despesa',
                                  style: estiloTextoBotao,
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              hText(
                                'Antes de publicar, verifique se todos os campos estão preenchidos corretamente!',
                                context,size:30
                              )
                            ],
                          ))),
                ])),
          )),
    );
  }
}
