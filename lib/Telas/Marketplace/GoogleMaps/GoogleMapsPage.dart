import 'dart:core';

import 'package:bocaboca/Objetos/User.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GoogleMapsPage extends StatefulWidget {
  User user;

  GoogleMapsPage({Key key, this.user}) : super(key: key);

  @override
  _GoogleMapsPageState createState() {
    return _GoogleMapsPageState();
  }
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
   List<Marker>  marcas = [];
  @override
  void initState() {
    super.initState();
      marcas.add(Marker(markerId: MarkerId(widget.user.id), draggable: false,position: LatLng(widget.user.endereco.lat, widget.user.endereco.lng), ));
      markers = Set.from(marcas);
  }

  @override
  void dispose() {
    super.dispose();
  }
  GoogleMapController googlemapController;
  Location location = new Location();
  Set<Marker> markers;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children:<Widget>[GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(widget.user.endereco.lat,widget.user.endereco.lng), zoom: 15), onMapCreated: _onMapCreated , myLocationEnabled: true, compassEnabled: true,markers: markers, ), ]);
  }

  _onMapCreated(GoogleMapController controller){
         setState(() {
           googlemapController = controller;
             
         });
  }

  _animacaoParaUser()async{

  }
}