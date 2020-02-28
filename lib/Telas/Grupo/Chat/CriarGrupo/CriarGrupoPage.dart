import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Message.dart';
import 'package:bocaboca/Objetos/Sala.dart';

class CriarGrupoPage extends StatefulWidget {
  @override
  _CriarGrupoPageState createState() {
    return _CriarGrupoPageState();
  }
}



class _CriarGrupoPageState extends State<CriarGrupoPage> {
  final _formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  Future getImage() async {
    showDialog(context:context, builder: (context) {
      return AlertDialog( shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                defaultActionButton('Camera', context, () {
                                  ImagePicker.pickImage(
                                    source: ImageSource.camera,
                                    ).timeout(Duration(seconds: 30)).then((image) async {
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
                                            child: new FlareActor("assets/dice20.flr",
                                                                      alignment: Alignment.center,
                                                                      fit: BoxFit.contain,
                                                                      animation: "Spin20")),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        progress: 0.0,
                                        maxProgress: 100.0,
                                        progressTextStyle: TextStyle(
                                            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                                        messageTextStyle: TextStyle(
                                            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
                                    pr.show();
                                    foto = await uploadPicture(
                                      image.path,
                                      );
                                    setState(() {});
                                    pr.dismiss();
                                    dToast('Salvando Foto!');
                                  }).catchError((err) {
                                    print('ERRO NO IMAGE PICKER ${err.toString()}');
                                  });
                                },icon:Icons.camera),
                                defaultActionButton('Galeria', context, () {
                                  ImagePicker.pickImage(
                                    source: ImageSource.gallery,
                                    ).timeout(Duration(seconds: 30)).then((image) async {

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
                                            child: new FlareActor("assets/dice20.flr",
                                                                      alignment: Alignment.center,
                                                                      fit: BoxFit.contain,
                                                                      animation: "Spin20")),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        progress: 0.0,
                                        maxProgress: 100.0,
                                        progressTextStyle: TextStyle(
                                            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                                        messageTextStyle: TextStyle(
                                            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
                                    pr.show();
                                    foto = await uploadPicture(
                                      image.path,
                                      );
                                    setState(() {});
                                    pr.dismiss();
                                    dToast('Salvando Foto!');
                                  }).catchError((err) {
                                    print('ERRO NO IMAGE PICKER ${err.toString()}');
                                  });
                                },icon:Icons.photo),
                              ],
                              ),
                          );
    });
  }
  String foto;
  TextEditingController nomeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
        'Criar Grupo',
        context,
        showBack: true,
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => getImage(),
                  child: CircleAvatar(
                      radius: (((getAltura(context) + getLargura(context)) /
                          2) *
                          .2),
                      backgroundColor: Colors.transparent,
                      child: foto != null
                             ? Image(
                        image: CachedNetworkImageProvider(foto),
                        )
                             : Image(
                        image:
                        AssetImage('assets/no_pic_character.png'),
                        )),
                  ),
                DefaultField(context: context,
                    hint: 'Vendas',
                    label: 'Nome do grupo',
                    capitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    controller: nomeController),
                sb,
                MaterialButton(
                    onPressed: () {
                      Sala s = new Sala(
                        created_at: DateTime.now(),
                        updated_at: DateTime.now(),
                        name: nomeController.text,
                        sala: null,
                        lastMessage: Message(
                            msg: '${nomeController.text} Criado!',
                            imgUrl: null,
                            senderFoto: null,
                            senderId: Helper.localUser.id,
                            senderName: Helper.localUser.nome,
                            timestamp: DateTime.now()),
                        deleted_at: null,
                        membros: [Helper.localUser.id],
                        isPrivate: false,
                        meta: {
                          Helper.localUser.id: {
                            'foto':
                                'https://scontent.fxap1-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmDYUVdstWP8Bj-dw1oUlqrsFIl9ZsHa01otbUpuqDyMmbqL3nS2JYnTUyCA48EMaY&_nc_ht=scontent.fxap1-1.fna&oh=4c532bf6d3e14d1f295f82d73aea05bd&oe=5DB5D8D7',
                            'NonRead': 0,
                            'partnerName': nomeController.text,
                            'isAdm': true,
                          },
                        },
                      );
                      chatRef.add(s.toJson()).then((v) {
                        s.id = v.documentID;
                        s.foto = foto;
                        s.sala = v.documentID;
                        chatRef.document(s.id).updateData(s.toJson()).then((d) {
                          print('Grupo Criado Com Sucesso');
                          dToast('Grupo Criado Com Sucesso!');
                          Helper.fbmsg.subscribeToTopic(s.id);
                          Navigator.of(context).pop();
                        });
                      });
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
                                      Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                'Criar Grupo',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            Text(
                              'Antes de criar, verifique se todos os campos estão preenchidos corretamente!',
                              style: estiloTextoRodape,
                            )
                          ],
                        ))),
              ],
            )),
      )),
    );
  }
}
