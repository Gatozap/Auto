import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Personagem.dart';

import 'PericiasPage.dart';

class BackgroundPage extends StatefulWidget {
  Personagem personagem;
  BackgroundPage({Key key, this.personagem}) : super(key: key);

  @override
  _BackgroundPageState createState() {
    return _BackgroundPageState();
  }
}

class _BackgroundPageState extends State<BackgroundPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController bgcontroller = TextEditingController();
  bool hasDone = false;
  @override
  Widget build(BuildContext context) {
    if(widget.personagem.bg != null){
      if(!hasDone) {
        bgcontroller.text = widget.personagem.bg;
        hasDone = true;
      }
    }
    return Scaffold(
      appBar: myAppBar('Background de ${widget.personagem.nome}', context,
          showBack: true),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              sb,
              sb,
              DefaultField(
                  minLines: 1,
                  context: context,
                  maxLines: 500,
                  controller: bgcontroller,
                  hint:
                      'Quando eu tinha 7 anos de idade, minha vila foi atacada por orcs e jurei me vingar dos orcs malignos que mataram meus pais, por isso me tornei um ${widget.personagem.classe}'),
              defaultActionButton('salvar background', context, () {
                widget.personagem.bg = bgcontroller.text;
                personagensRef
                    .document(widget.personagem.id)
                    .updateData(widget.personagem.toJson())
                    .then((v) {
                  dToast('Background salvo com sucesso');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PericiasPage(personagem : widget.personagem )));
                });

              })
            ],
          ),
        ),
      ),
    );
  }
}
