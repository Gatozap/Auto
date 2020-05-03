import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Agendamento.dart';
import 'package:autooh/Objetos/Instalacao.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Telas/Admin/Agendamento/AgendamentoListController.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarCarroPage.dart';
import 'package:flutter/material.dart';

class AgendamentoListPage extends StatefulWidget {
  Parceiro parceiro;
  AgendamentoListPage({this.parceiro});

  @override
  _AgendamentoListPageState createState() => _AgendamentoListPageState();
}

class _AgendamentoListPageState extends State<AgendamentoListPage> {
  AgendamentoListController alc;
  @override
  Widget build(BuildContext context) {
    if (alc == null) {
      alc = AgendamentoListController(parceiro: widget.parceiro);
    }
    return Scaffold(
      appBar: myAppBar('Agendamentos', context, showBack: true),
      body: StreamBuilder<List<Instalacao>>(
          stream: alc.outInstalacoes,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return LoadingWidget(
                  'Nenhum agendamento', 'Carregando Agendamentos');
            }
            if (snapshot.data.length == 0) {
              return LoadingWidget(
                  'Nenhum agendamento', 'Carregando Agendamentos');
            }
            return ListView.builder(
              itemBuilder: (context, i) {
                return InstalacaoListItem(snapshot.data[i], context);
              },
              itemCount: snapshot.data.length,
            );
          }),
    );
  }

  Widget InstalacaoListItem(Instalacao data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VisualizarCarroPage(
                    carro: data.id_carro,
                    user: data.id_usuario,
                  )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.parceiro == null
                ? hText(data.id_parceiro != null ? data.id_parceiro.nome : '',
                    context,
                    color: Colors.green)
                : Container(),
            hText(
              "Motorista: ${data.id_usuario.nome}",
              context,
            ),
            hText(
              "Agendado para: ${FormatarHora(data.hora_agendada)}",
              context,
            ),
            hText(
              "Placa: ${data.id_carro.placa}",
              context,
            ),
            hText(
              "Modelo: ${data.id_carro.modelo}",
              context,
            ),
            hText('Campanha: ${data.id_campanha.nome_campanha}', context),
          ],
        ),
      ),
    );
  }
}
