import 'dart:io';

import 'package:autooh/Helpers/DateSelector.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ParceirosBloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_action.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'LocationController.dart';
import 'addEnderecoController.dart';

class ParceirosCadastrarPage extends StatefulWidget {
  Parceiro parceiro;

  ParceirosCadastrarPage({Key key,this.parceiro}) : super(key: key);

  @override
  _ParceirosCadastrarPageState createState() => _ParceirosCadastrarPageState();
}

class _ParceirosCadastrarPageState extends State<ParceirosCadastrarPage> {
  @override
  void initState() {
    super.initState();
    if(pc == null){
      pc = ParceirosBloc(parceiro: widget.parceiro);
    }
     if(aec == null){
       aec =   AddEnderecoController(ue);
     }
    if (ue == null) {
      ue = new Endereco.Empty();
    }
  }
  AddEnderecoController aec;
  Endereco ue;
  FocusNode myFocusNode;
  bool isPressed = false;
  bool onLoad = true;
  bool isCadastrarPressed = false;
  ParceirosBloc pc;
  Parceiro parceiro;
  final _formKey = GlobalKey<FormState>();
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  var controlerTelefone = new MaskedTextController( text: '', mask: '(00) 0 0000-0000');
  var controlerHoraIni = new MaskedTextController( text: '', mask: '00:00');
  var controlerHoraFim = new MaskedTextController( text: '', mask: '00:00');
  @override
  Widget build(BuildContext context) {
    BasicTimeField horaIniField =  BasicTimeField(text: 'Hora Inicial',  icon: FontAwesomeIcons.solidCalendarPlus,controller: controlerHoraIni, );
    BasicTimeField horaFimField =  BasicTimeField(text: 'Hora Fim',  icon: FontAwesomeIcons.solidCalendarPlus, controller: controlerHoraFim, );
     TimeOfDay horaini;
     TimeOfDay horafim;
    if(widget.parceiro != null) {
      controllerNome.text = widget.parceiro.nome;
      controlerHoraIni.text = widget.parceiro.hora_ini.toString();
      controlerHoraFim.text = widget.parceiro.hora_fim.toString();
      controlerTelefone.text = widget.parceiro.telefone;
      controllerCidade.text = widget.parceiro.endereco.cidade;
       controllerEndereco.text = widget.parceiro.endereco.endereco;
       controllerBairro.text =  widget.parceiro.endereco.bairro;
       controllerComplemento.text =  widget.parceiro.endereco.complemento;
       controllerNumero.text =  widget.parceiro.endereco.numero;
             if(widget.parceiro.hora_ini != null){
                horaini = widget.parceiro.hora_ini;
                horaIniField =   BasicTimeField( text: 'Hora Inicial',
                  icon: FontAwesomeIcons.solidCalendarPlus,controller: controlerHoraIni,);
             }
      if(widget.parceiro.hora_fim != null){
        horaini = widget.parceiro.hora_fim;
        horaIniField =   BasicTimeField( text: 'Hora Fim',
          icon: FontAwesomeIcons.solidCalendarPlus,controller: controlerHoraFim,);
      }
      parceiro = widget.parceiro;
      pc.inParceiroSelecionado.add(parceiro);
    }
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Color(0xFFE8F5E9),
          Color(0xFFE0F7FA),
        ],
      ),
    );

    return Scaffold(appBar: myAppBar(widget.parceiro == null?'Cadastrar Parceiro': 'Editar Parceiro', context,showBack: true),
           body: Container(width: getLargura(context),  height: getAltura(context),
           decoration: linearGradient,
           padding: EdgeInsets.all(1),
           child: StreamBuilder<Parceiro>(
                    stream: pc.outParceiroSelecionado,
               builder: (context, AsyncSnapshot snapshot) {
                  parceiro = snapshot.data;
                 if (parceiro == null) {
                 parceiro = new Parceiro();
                 }

                  if(parceiro.segunda == null){
                    parceiro.segunda = false;
                  }
                  if(parceiro.terca == null){
                    parceiro.terca = false;
                  }

                  if(parceiro.quarta == null){
                    parceiro.quarta = false;
                  }
                  if(parceiro.quinta == null){
                    parceiro.quinta = false;
                  }
                  if(parceiro.sexta == null){
                    parceiro.sexta = false;
                  }
                  if(parceiro.sabado == null){
                    parceiro.sabado = false;
                  }
                  if(parceiro.domingo == null){
                    parceiro.domingo = false;
                  }


                 return SingleChildScrollView(
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.min,children: <Widget>[
                           GestureDetector(
                             onTap: () => showDialog(
                                 context: context,
                                 builder: (context) {
                                   return Padding(
                                     padding: const EdgeInsets.all(15.0),
                                     child: AlertDialog(
                                       title:
                                       hText("Selecione uma opção", context),
                                       content: SingleChildScrollView(
                                         child: ListBody(
                                           children: <Widget>[
                                             defaultActionButton(
                                                 'Galeria', context, () {
                                               getImage();
                                               Navigator.of(context).pop();
                                             }, icon: MdiIcons.face),
                                             sb,
                                             defaultActionButton(
                                                 'Camera', context, () {
                                               getImageCamera();
                                               Navigator.of(context).pop();
                                             }, icon: MdiIcons.camera)
                                           ],
                                         ),
                                       ),
                                     ),
                                   );
                                 }),
                             child: CircleAvatar(
                                 radius: (((getAltura(context) +
                                     getLargura(context)) /
                                     2) *
                                     .2),
                                 backgroundColor: Colors.transparent,
                                 child:

                                 parceiro.foto != null
                                     ? Image(
                                   image: CachedNetworkImageProvider(
                                       parceiro.foto),
                                 )
                                     : Stack(children: <Widget>[
                                   Positioned(
                                     child: Image(
                                         image: AssetImage(
                                             'assets/campanha_sem_foto.png')),
                                   ),
                                   Positioned(
                                     top: 175,
                                     left: 150,
                                     child: Center(
                                       child: CircleAvatar(
                                         radius: 15,
                                         backgroundColor: Colors.black,
                                         child: Icon(
                                           MdiIcons.cameraOutline,
                                           color: Colors.white,
                                         ),
                                       ),
                                     ),
                                   ),
                                 ])),
                           ),

                           Padding(
                             padding: EdgeInsets.only(left: 40, right: 20, top: 20),
                             child: TextFormField(
                                       keyboardType: TextInputType.number,
                               controller: controlerTelefone,
                               validator: (value) {
                                 if (value.isEmpty) {
                                   if (isCadastrarPressed) {
                                     return 'É necessário preencher o Telefone';
                                   }
                                 }
                               },
                               decoration: DefaultInputDecoration(
                                 context,
                                 icon: FontAwesomeIcons.mobileAlt,
                                 hintText: '(99) 9 9999-9999',
                                 labelText: 'Telefone',
                               ),
                               autovalidate: true,
                             ),
                           ),

                           Padding(
                             padding: EdgeInsets.only(left: 40, right: 20, top: 20),
                             child: TextFormField(
                            
                               controller: controllerNome,
                               validator: (value) {
                                 if (value.isEmpty) {
                                   if (isCadastrarPressed) {
                                     return 'É necessário preencher o Nome';
                                   }
                                 }
                               },
                               decoration: DefaultInputDecoration(
                                 context,
                                 icon: FontAwesomeIcons.user,
                                 hintText: 'Instala Anúncios Mark',
                                 labelText: 'Nome Parceiro',
                               ),
                               autovalidate: true,
                             ),
                           ),
                           Padding(
                               padding: const EdgeInsets.all(24.0),
                               child: Container(
                                   height:
                                   MediaQuery.of(context).size.height * .85,
                                   child: StreamBuilder<Endereco>(
                                       stream: aec.outEndereco,
                                       builder: (context, snapshot) {
                                         ue = snapshot.data;
                                         if (myFocusNode == null) {
                                           myFocusNode = FocusNode();
                                         }

                                         if (ue != null) {

                                                         controllerCEP.text =
                                                         ue.cep != null ? ue
                                                             .cep : '';

                                           if(controllerCidade.text.isEmpty) {
                                             controllerCidade.text =
                                             ue.cidade != null
                                                 ? ue.cidade
                                                 : '';
                                           }
                                           if(controllerEndereco.text.isEmpty) {
                                             controllerEndereco.text =
                                             ue.endereco != null
                                                 ? ue.endereco
                                                 : '';
                                           }
                                           if(controllerBairro.text.isEmpty) {
                                             controllerBairro.text =
                                             ue.bairro != null
                                                 ? ue.bairro
                                                 : '';
                                           }
                                           if (controllerNumero.text.isEmpty) {
                                             controllerNumero.text =
                                             ue.numero != null
                                                 ? ue.numero
                                                 : '';
                                           }
                                           if (controllerComplemento
                                               .text.isEmpty) {
                                             controllerComplemento.text =
                                             ue.complemento != null
                                                 ? ue.complemento
                                                 : '';
                                           }
                                         }
                                         return SingleChildScrollView(
                                             child: Form(
                                                 key: _formKey,
                                                 child: Column(
                                                     mainAxisAlignment:
                                                     MainAxisAlignment
                                                         .center,
                                                     children: <Widget>[
                                                       sb,
                                                       sb,
                                                       Divider(color: corPrimaria),
                                                       sb,
                                                       Text(
                                                         'Cadastre seu endereço',
                                                         style: TextStyle(
                                                             color: Colors.black,
                                                             fontSize: 20),
                                                       ),
                                                       sb,
                                                       Divider(color: corPrimaria),
                                                       sb,
                                                       defaultActionButton(
                                                           'Buscar Localização',
                                                           context, () async {
                                                             print('apertou');
                                                         aec.inEndereco.add(
                                                             await lc
                                                                 .getEndereco());
                                                         Future.delayed(Duration(seconds:1)).then((v) async {
                                                           aec.inEndereco.add(
                                                               await lc
                                                                   .getEndereco());
                                                         });
                                                       }, icon: null),
                                                       sb,
                                                       sb,
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           onFieldSubmitted:
                                                           aec.FetchCep,
                                                           controller:
                                                           controllerCEP,
                                                           keyboardType:
                                                           TextInputType
                                                               .numberWithOptions(),
                                                           validator: (value) {
                                                             if (value.isEmpty) {
                                                               if (isCadastrarPressed) {
                                                                 return 'É necessário preencher o CEP';
                                                               }
                                                             } else {
                                                               if (value
                                                                   .length !=
                                                                   9) {
                                                                 if (isCadastrarPressed) {
                                                                   return 'CEP inválido';
                                                                 }
                                                               } else {
                                                                 if (value
                                                                     .length ==
                                                                     9) {
                                                                   if (ue.cep !=
                                                                       value) {
                                                                     aec.FetchCep(
                                                                         value);
                                                                     ue.cep =
                                                                         value;
                                                                     aec.inEndereco
                                                                         .add(
                                                                         ue);
                                                                     FocusScope.of(
                                                                         context)
                                                                         .requestFocus(
                                                                         myFocusNode);
                                                                   }
                                                                 }
                                                               }
                                                             }
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon: Icons
                                                                 .assistant_photo,
                                                             hintText:
                                                             '00000-000',
                                                             labelText: 'CEP',
                                                           ),
                                                           autovalidate: true,
                                                         ),
                                                       ),
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           controller:
                                                           controllerCidade,
                                                           validator: (value) {
                                                             if (value.isEmpty) {
                                                               return 'É necessário preencher a Cidade';
                                                             } else {
                                                               ue.cidade = value;
                                                               aec.inEndereco
                                                                   .add(ue);
                                                             }
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon: Icons
                                                                 .location_city,
                                                             hintText:
                                                             'São Paulo',
                                                             labelText: 'Cidade',
                                                           ),
                                                         ),
                                                       ),
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           controller:
                                                           controllerBairro,
                                                           validator: (value) {
                                                             if (value.isEmpty) {
                                                               return 'É necessário preencher o Bairro';
                                                             } else {
                                                               ue.bairro = value;
                                                               aec.inEndereco
                                                                   .add(ue);
                                                             }
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon: Icons.home,
                                                             hintText: 'Centro',
                                                             labelText: 'Bairro',
                                                           ),
                                                         ),
                                                       ),
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           controller:
                                                           controllerEndereco,
                                                           validator: (value) {
                                                             if (value.isEmpty) {
                                                               return 'É necessário preencher o Endereço';
                                                             } else {
                                                               ue.endereco =
                                                                   value;
                                                               aec.inEndereco
                                                                   .add(ue);
                                                             }
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon: Icons
                                                                 .add_location,
                                                             hintText:
                                                             'Rua da Saúde',
                                                             labelText:
                                                             'Endereço',
                                                           ),
                                                         ),
                                                       ),
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           keyboardType:
                                                           TextInputType
                                                               .number,
                                                           controller:
                                                           controllerNumero,
                                                           focusNode:
                                                           myFocusNode,
                                                           validator: (value) {
                                                             if (value.isEmpty) {
                                                               return 'É necessário preencher o Número';
                                                             } else {
                                                               ue.numero = value;
                                                               aec.inEndereco
                                                                   .add(ue);
                                                             }
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon:
                                                             Icons.filter_1,
                                                             hintText: '3001',
                                                             labelText: 'Número',
                                                           ),
                                                         ),
                                                       ),
                                                       new Padding(
                                                         padding: ei,
                                                         child: TextFormField(
                                                           controller:
                                                           controllerComplemento,
                                                           validator: (value) {
                                                             ue.complemento =
                                                                 value;
                                                             aec.inEndereco
                                                                 .add(ue);
                                                           },
                                                           decoration:
                                                           DefaultInputDecoration(
                                                             context,
                                                             icon: Icons.home,
                                                             hintText:
                                                             'Apto. 163',
                                                             labelText:
                                                             'Complemento',
                                                           ),
                                                         ),
                                                       ),

                                                     ])));
                                       }))),
                          Divider(color: corPrimaria,),sb,
                           hText('Dias da Semana que Atende', context)
                          , sb,Divider(color: corPrimaria,),sb,

                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.segunda,
                                 'Atende nas Segundas',
                                 context, () {
                               parceiro.segunda =
                               ! parceiro.segunda;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.terca,
                                 'Atende nas Terças',
                                 context, () {
                               parceiro.terca =
                               ! parceiro.terca;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.quarta,
                                 'Atende nas Quartas',
                                 context, () {
                               parceiro.quarta =
                               ! parceiro.quarta;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.quinta,
                                 'Atende nas Quintas',
                                 context, () {
                               parceiro.quinta =
                               ! parceiro.quinta;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.sexta,
                                 'Atende nas Sextas',
                                 context, () {
                               parceiro.sexta =
                               ! parceiro.sexta;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.sabado,
                                 'Atende nos Sábados',
                                 context, () {
                               parceiro.sabado =
                               ! parceiro.sabado;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(left: 40.0, bottom: 20),
                             child: defaultCheckBox(
                                 parceiro.domingo,
                                 'Atende nos Domingos',
                                 context, () {
                               parceiro.domingo =
                               ! parceiro.domingo;
                               pc.pp = parceiro;
                               pc.inParceiroSelecionado.add(pc.pp);
                             }),
                           ),
                          sb, Divider(color: corPrimaria),sb, hText('Hora de funcionamento', context)
                               , sb, Divider(color: corPrimaria),sb,
                          /* DefaultField(
                               padding: EdgeInsets.only(left: 100, right: 120),
                               controller: controlerHoraIni,
                               hint: '08:00',
                               context: context,
                               label: 'Hora Inicial',
                               expands: false,
                               validator: (value) {
                                 if (value.isEmpty) {
                                   if (isCadastrarPressed) {
                                     return 'É necessário preencher a Hora Inicial';
                                   }
                                 }
                               },
                               icon: FontAwesomeIcons.clock,
                               keyboardType: TextInputType.number),  */
                          horaIniField,
                           horaFimField
                       ,sb,sb,

                           MaterialButton( child: Padding(
                             padding:  EdgeInsets.only(left: 30.0, right:  30, top: 5 , bottom: 5),
                             child: hText(widget.parceiro == null? 'Cadastrar':'Editar', context, color: corPrimaria, weight: FontWeight.bold, size: 80),
                           ),      color: Colors.yellowAccent,
                             shape: RoundedRectangleBorder(
                                 borderRadius:
                                 BorderRadius.circular(60)), onPressed: () async{
                             parceiro.nome = controllerNome.text;
                             print('aqui controler hora ini ${controlerHoraIni.text}');
                             parceiro.hora_ini = TimeOfDay(hour: int.parse(controlerHoraIni.text.split(":")[0]), minute: int.parse(controlerHoraIni.text.split(":")[1]));

                             parceiro.hora_fim = TimeOfDay(hour: int.parse(controlerHoraFim.text.split(":")[0]), minute: int.parse(controlerHoraFim.text.split(":")[1]));
                              parceiro.telefone = controlerTelefone.text;
                                  parceiro.created_at = DateTime.now();
                                
                             List<Endereco> end = new List();
                              Endereco e = new Endereco(
                               cep: controllerCEP.text,
                               bairro: controllerBairro.text,
                               complemento: controllerComplemento.text,
                               cidade: controllerCidade.text,
                               created_at: DateTime.now(),
                               endereco: controllerEndereco.text,
                                     numero: controllerNumero.text,

                              );
                             end.add(e);
                              parceiro.endereco = e;

                              widget.parceiro == null? parceirosRef.add(parceiro.toJson()).then((v) {
                               parceiro.id = v.documentID;
                                 parceirosRef.document(parceiro.id).updateData(parceiro.toJson()).then((v){
                                   dToast('Parceiro Criado com sucesso');
                                      
                                 });
                               Navigator.of(context).pop();
                                 }):
                              pc.EditarParceiro(
                                  parceiro)
                                  .then((v) {
                                dToast(
                                    'Parceiro editado com sucesso!');
                                Navigator.of(context).pop();
                              });
                             },)
                         ],),
                       ),


                 );
               }
           ),
           ),



    );
  }
  ProgressDialog pr;

  Future getImageCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
   parceiro.foto = await uploadPicture(
      image.path,
    );
    pc.updateParceiro(parceiro);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    parceiro.foto = await uploadPicture(
      image.path,
    );
    pc.updateParceiro(parceiro);
    pr.dismiss();
    dToast('Salvando Foto!');
  }
}