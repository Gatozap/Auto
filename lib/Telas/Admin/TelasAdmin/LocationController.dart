



import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Objetos/location.dart';
import 'package:autooh/Telas/Card/bloc_provider.dart';
import 'package:geocoder/geocoder.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class LocationController extends BlocBase {
  BehaviorSubject<LatLng> controllerUserLocation =
  new BehaviorSubject<LatLng>();
  LatLng userLocation;

  BehaviorSubject<Endereco> _controllerEndereco =
  new BehaviorSubject<Endereco>();
  Stream<Endereco> get outEndereco => _controllerEndereco.stream;
  Sink<Endereco> get inEndereco => _controllerEndereco.sink;
  Endereco endereco;
  Stream<LatLng> get outUserLocation => controllerUserLocation.stream;
  Sink<LatLng> get inUserLocation => controllerUserLocation.sink;
  var location = new Location();
  Future<Map<String, double>> _getLocation() async {
    try {
      bool enable = await location.serviceEnabled();
      if (enable) {
        location.onLocationChanged().listen((LocationData currentLocation) {
          print('AQUI USER LOCATION ${currentLocation.latitude}');
          print('AQUI USER LOCATION ${currentLocation.longitude}');
          userLocation =
          new LatLng(currentLocation.latitude, currentLocation.longitude);
          inUserLocation.add(userLocation);
        });
      } else {
        location.requestService().then((v) {
          if (v) {
            location.getLocation().then((data) {
              userLocation = new LatLng(data.latitude, data.longitude);
              inUserLocation.add(userLocation);
              print('ENTROU AQUI ${userLocation}');
              getEndereco();
            });
            location.onLocationChanged().listen((LocationData currentLocation) {
              print('AQUI USER LOCATION ${currentLocation.latitude}');
              print('AQUI USER LOCATION ${currentLocation.longitude}');
              userLocation = new LatLng(
                  currentLocation.latitude, currentLocation.longitude);
              inUserLocation.add(userLocation);
              getEndereco();
            });
          } else {
            _getLocation();
          }
        });
      }
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      print(e.toString());
    }
  }

  Future<Endereco> getEndereco () async {
    try {
      if (userLocation != null) {
        print('RODANDO LALALA');
        List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(userLocation.latitude, userLocation.longitude)).catchError((onError){
          print('ERRO AO BUSCAR LOCALIZAÇÂO ${onError.toString()}');
          endereco = Endereco(
              cidade:'',
              cep:'',
              bairro:'',
              endereco: '',
              numero:'',
              complemento:'',
              lat:userLocation.latitude,
              lng:userLocation.longitude,
              estado:'',
              created_at:DateTime.now(),
              updated_at:DateTime.now(),
              deleted_at:null
          );
          inEndereco.add(endereco);
          return endereco;
        });
        Address first = addresses.first;
        print("ENDEREÇO ${first.featureName} : ${first.addressLine}");
        print('ENDERECO ${first.toString()}');
        endereco = Endereco(
            cidade:first.subAdminArea,
            cep:first.postalCode,
            bairro:first.subLocality,
            endereco: first.thoroughfare,
            numero:first.featureName,
            complemento:'',
            lat:userLocation.latitude,
            lng:userLocation.longitude,
            estado:first.adminArea,
            created_at:DateTime.now(),
            updated_at:DateTime.now(),
            deleted_at:null
        );
        inEndereco.add(endereco);
        print('RETORNOU ENDEREÇO LALALA ${endereco.toString()}');
        return endereco;
      }
      return null;
    }catch(err){
      print('Error: ${err.toString()}');
    }
  }


  LocationController() {
    _getLocation();
  }

  @override
  void dispose() {
    controllerUserLocation.close();
    _controllerEndereco.close();
  }
}

LocationController lc = new LocationController();