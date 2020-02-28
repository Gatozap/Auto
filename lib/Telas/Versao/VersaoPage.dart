import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';

class VersaoPage extends StatefulWidget {
  VersaoPage({Key key}) : super(key: key);

  @override
  _VersaoPageState createState() {
    return _VersaoPageState();
  }
}

class _VersaoPageState extends State<VersaoPage> {
  String _platformVersion = 'Unknown';
  String _projectVersion = '';
//  String _projectCode = '';
//  String _projectName = '';
  AndroidDeviceInfo androidInfo;
  IosDeviceInfo iosDeviceInfo;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
    } else {
      androidInfo = await deviceInfo.androidInfo;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    String projectAppID;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectAppID = await GetVersion.appID;
    } on PlatformException {
      projectAppID = 'Failed to get app ID.';
    }

    String projectName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectName = await GetVersion.appName;
    } on PlatformException {
      projectName = 'Failed to get app name.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _projectVersion = projectVersion;
//      _projectCode = projectCode;
//      _projectName = projectName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('bocaboca', context, showBack: true),
      body: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Container(
              height: 10.0,
            ),
//          new ListTile(
//            leading: new Icon(Icons.info),
//            title: const Text('Nome'),
//            subtitle: new Text(_projectName),
//            ),
            new Container(
              height: 10.0,
            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: const Text('Sistema operacional'),
              subtitle: new Text(_platformVersion),
            ),
//            new Divider(
//              height: 20.0,
//            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: const Text('Versão'),
              subtitle: new Text(_projectVersion),
            ),
//            new Divider(
//              height: 20.0,
//            ),
//            new ListTile(
//              leading: new Icon(Icons.info),
//              title: const Text('Codigo da Versão'),
//              subtitle: new Text(_projectCode),
//            ),
//            new Divider(
//              height: 20.0,
//            ),
//            new ListTile(
//              leading: new Icon(Icons.info),
//              title: const Text('Tamanho da Tela'),
//              subtitle: new Text(
//                  '${MediaQuery.of(context).size.height.toStringAsFixed(0)}x${MediaQuery.of(context).size.width.toStringAsFixed(0)}'),
//            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: const Text('Tamanho da Tela'),
              subtitle: new Text(
                  '${MediaQuery.of(context).size.height.toStringAsFixed(0)}x${MediaQuery.of(context).size.width.toStringAsFixed(0)}'),
            ),
          ],
        ),
      ),
    );
  }
}
