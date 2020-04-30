import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/SolicitacoesListController.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/solicitacao_list_item.dart';
import 'package:flutter/material.dart';

class SolicitacoesListPage extends StatefulWidget {
  User user;
  Campanha c;
  bool isUser;
  SolicitacoesListPage({Key key, this.user,this.c,this.isUser = false}) : super(key: key);

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
      slc = SolicitacoesListController(user:widget.user,campanha: widget.c);
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
              return SolicitacaoListItem(snap.data[i],isUser:widget.isUser);
            },itemCount: snap.data.length,);
          },
        ));
  }
}


