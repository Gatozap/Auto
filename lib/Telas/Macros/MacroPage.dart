import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Telas/Dice/DiceWidget.dart';

class TutorialMacroPage extends StatefulWidget {
  Personagem personagem;
  TutorialMacroPage({this.personagem, Key key}) : super(key: key);

  @override
  _TutorialMacroPageState createState() {
    return _TutorialMacroPageState();
  }
}

class _TutorialMacroPageState extends State<TutorialMacroPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String text;
  List<String> ultimaRolagem;
  TextEditingController macroController = TextEditingController();
  String meuMacroTeste;
  List<String> meuMacroUltimaRolagem;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Tutorial Macros', context),
      body: Container(
        width: getLargura(context),
        height: getAltura(context),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 8),child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  sb,
                  Container(
                    child: hText(
                        'Aqui você pode criar os seus macros personalizados e agilizar as rolagens',
                        context,
                        size: 54,
                        textaling: TextAlign.center),
                    width: getLargura(context),
                  ),
                  sb,
                  hText('Para criar seu macro você precisa usar um padrão especifico para as rolagens\nExemplo: Macro de multiplos ataques \nCorpo a Corpo + dano', context,size: 44),
                  hText(text != null? 'Resultados: \n$text':'', context,size: 44),
                  sb,sb,
                  hText('Seus Bonus de Corpo a Corpo são ${widget.personagem.cac}', context,size: 44),
                  defaultActionButton('#1d20+cac #1d8+for+dex', context, (){

                    setState(() {
                      ultimaRolagem = runMacro('#1d20+cac #1d8+for+dex',widget.personagem);
                      text = ultimaRolagem[0];
                    });

                  },icon: null),
                  sb,
                  hText('Note que todo comando é iniciado pelo dado + algo\n Ex: #1d20+3',context,size: 44),
                  defaultActionButton('#1d20+3', context, (){

                    setState(() {
                      ultimaRolagem = runMacro('#1d20+3',widget.personagem);
                      text = ultimaRolagem[0];
                    });

                  },icon: null),

                  hText('Veja a lista de comandos Disponiveis e faça o seu',context,size: 44),
                  defaultActionButton('Ver Lista', context, (){
                    developing(context);
                  },icon: null),
                  DefaultField(hint: '1d20+ad',label: 'Crie seu Macro',controller: macroController,context: context),
                  defaultActionButton('Testar meu Macro', context, (){
                    setState(() {
                      meuMacroUltimaRolagem = runMacro(macroController.text,widget.personagem);
                      meuMacroTeste = meuMacroUltimaRolagem[0];
                    });
                  },icon: null),
                  hText(meuMacroTeste != null? 'Resultado do meu macro: \n$meuMacroTeste':'', context,size: 44),
                  ]
              ),)
            ),
           // DicesWidget(context).getDiceWidget(),
          ],
        ),
      ),
    );
  }


}
