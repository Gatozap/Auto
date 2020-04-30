import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/SolicitacoesListController.dart';
import 'package:flutter/material.dart';

class SolicitacoesListPage extends StatefulWidget {
  SolicitacoesListPage({Key key}) : super(key: key);

  @override
  _SolicitacoesListPageState createState() {
    return _SolicitacoesListPageState();
  }
}

class _SolicitacoesListPageState extends State<SolicitacoesListPage> {
  @override
  void initState() {
    super.initState();
  }

  SolicitacoesListController slc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (slc == null) {
      slc = SolicitacoesListController();
    }
    // TODO: implement build
    return Scaffold(
        appBar: myAppBar('Solicitacoes', context, showBack: true),
        body: StreamBuilder(
          stream: slc.outSolicitacoes,
          builder: (context, snap) {
            if(snap.data == null){
              return LoadingWidget('Nenhuma solicitação encontrada!', 'Procurando Solicitacoes');
            }
            return ListView.builder(itemBuilder: (context,i){
              return hText(snap.data[i].toString(),context);
            },itemCount: snap.data.length,);
          },
        ));
  }
}
