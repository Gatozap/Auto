import 'dart:io';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
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


  }
  bool isPressed = false;
  bool onLoad = true;
  bool isCadastrarPressed = false;
  ParceirosBloc pc;
  Parceiro parceiro;
  var controllerNome = new TextEditingController(text: '');
  var controlerTelefone = new MaskedTextController( text: '', mask: '(00) 0 0000-0000');
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(appBar: myAppBar('Cadastrar Parceiro', context,showBack: true),
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
                 if (onLoad) {
                   controllerNome.text = parceiro.nome;

                   onLoad = false;
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
                                 child: parceiro.foto != null
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

                            sb,Divider(color: corPrimaria,),sb,
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


                           MaterialButton( child: Padding(
                             padding:  EdgeInsets.only(left: 15.0, right:  15),
                             child: hText('Cadastrar', context, color: corPrimaria, weight: FontWeight.bold, size: 80),
                           ),      color: Colors.yellowAccent,
                             shape: RoundedRectangleBorder(
                                 borderRadius:
                                 BorderRadius.circular(60)), onPressed: () async{
                             parceiro.nome = controllerNome.text;
                              parceiro.telefone = controlerTelefone.text;
                             parceirosRef.add(parceiro.toJson()).then((v) {
                               parceiro.id = v.documentID;
                                 parceirosRef.document(parceiro.id).updateData(parceiro.toJson()).then((v){
                                   dToast('Parceiro Criado com sucesso');
                                 });

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