import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Personagem.dart';

class EntrarGrupoPage extends StatefulWidget {
  EntrarGrupoPage();

  @override
  _EntrarGrupoPageState createState() {
    return _EntrarGrupoPageState();
  }
}

class _EntrarGrupoPageState extends State<EntrarGrupoPage> {
  List<Personagem> personagens = new List();
  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 10; i++) {
      personagens.add(Personagem(nome: 'Joao ${i.toStringAsFixed(0)}'));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController tec = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Entrar Grupo', context, showBack: false, actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            developing(context);
          },
        )
      ]),
      body: Container(
        width: getLargura(context),
        height: getAltura(context),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            defaultActionButton('Entrar no Grupo', context, () {
              dToast(tec.text);
            },
                icon: Icons.monetization_on),
            hText('LAlalaa', context, textaling: TextAlign.center, size: 40),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: hText(personagens[index].nome, context),
                  );
                },
                itemCount: personagens.length,
                shrinkWrap: true,
              ),
            ),
            DefaultField(icon: Icons.person,                  context: context,label: 'Nome',hint: 'João',controller:tec ),
          ],
        ),
      ),
    );
  }
}
