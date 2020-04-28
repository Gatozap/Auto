import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/parceiros_cadastrar_page.dart';
import 'package:flutter/material.dart';

class ParceirosListPage extends StatefulWidget {
  ParceirosListPage({Key key}) : super(key: key);

  @override
  _ParceirosListPageState createState() {
    return _ParceirosListPageState();
  }
}

class _ParceirosListPageState extends State<ParceirosListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Parceiros', context, showBack: true, actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ParceirosCadastrarPage(parceiro: null)));
          },
        )
      ]),
    );
  }
}
