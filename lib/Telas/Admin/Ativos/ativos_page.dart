import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Ativo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'AtivosController.dart';

class AtivosPage extends StatefulWidget {
  AtivosPage({Key key}) : super(key: key);

  @override
  _AtivosPageState createState() => _AtivosPageState();
}

class _AtivosPageState extends State<AtivosPage> {
  AtivosController ac;
  GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    if (ac == null) {
      ac = AtivosController();
    }
    return Scaffold(
      appBar: myAppBar('Carros Ativos', context, showBack: true),
      body: StreamBuilder(
          stream: ac.outAtivos,
          builder: (context, snapshot) {
            return StreamBuilder<Object>(
                stream: ac.outLocalizacoes,
                builder: (context, snap) {
                  return FutureBuilder(
                      future: getMarkers(snap.data, snapshot.data),
                      builder: (context, future) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(-16.665136, -49.286041),
                            zoom: 16,
                          ),
                          zoomGesturesEnabled: true,
                          markers: future.data == null
                              ? Set<Marker>()
                              : future.data.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                        );
                      });
                });
          }),
    );
  }

  BitmapDescriptor sourceIcon;
  getMarkers(Map data, List ativos) async {
    print("INICIANDO MARKERS ${data.toString()}");
    List<Marker> markers;
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 4.5),
      "assets/marker.png",
    );
    markers = new List();

    data.forEach((k, position) {
      print("AQUI FOREACH ${position}");
      print('${position['latitude']}');
      print('${position['longitude']}');
      try {
        Ativo ativo;
        for (Ativo a in ativos) {
          if (k == a.id_corrida) {
            ativo = a;
          }
        }
        markers.add(Marker(
          markerId: MarkerId(k),
          position: LatLng(
            position['latitude'],
            position['longitude'],
          ),
          infoWindow: InfoWindow(
              title: '${ativo.carro.placa}', snippet: '${ativo.campanha.nome}'),
          icon: sourceIcon,
        ));
      } catch (err) {
        print('Erro ao criar marker ${err.toString()}');
      }
      print("ADICIONOU MARKER ${markers.length}");
    });
    print("AQUI MARKERS ${markers.length}");
    return markers;
  }
}
