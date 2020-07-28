import 'dart:io';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Relatorio.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Relatorios/relatorios_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RelatoriosPage extends StatefulWidget {
  RelatoriosPage({Key key}) : super(key: key);

  @override
  _RelatoriosPageState createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  RelatoriosController rc;
  @override
  Widget build(BuildContext context) {
    if (rc == null) {
      rc = RelatoriosController();
    }
    return Scaffold(
      appBar: myAppBar('Relatorios', context, showBack: true),
      body: StreamBuilder(
        stream: rc.outRelatorios,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          if (snapshot.data.length == 0) {
            return Container();
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return RelatorioListItem(snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }

  Future<String> _findLocalPath() async {
    final directory = !isIOS
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Widget RelatorioListItem(Relatorio data) {
    return GestureDetector(
      onTap: () async {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        if (statuses[Permission.storage] == PermissionStatus.granted) {
          // code of read or write file in external storage (SD card)

          dToast('Baixando Relatorio');
          String _localPath = (await _findLocalPath()) + Platform.pathSeparator;

          await FlutterDownloader.enqueue(
            url: await (await FirebaseStorage().getReferenceFromUrl(data.url))
                .getDownloadURL(),
            savedDir: _localPath,
            showNotification: true,
            openFileFromNotification: true,
          );

          dToast('Relatorio Salvo em ${_localPath}');
        } else {
          dToast('o App não tem permissão para gravar arquivos =/');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sb,
          hText(data.nome == null ? 'Relatorio sem nome' : data.nome, context),
          hText('Enviando em: ${FormatarHora(data.created_at)}', context),
          Divider(),
          sb,
        ],
      ),
    );
  }
}
