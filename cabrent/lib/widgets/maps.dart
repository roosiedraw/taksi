import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

double _originLatitude = 40.1921188;
double _originLongitude = 29.0643523;
LatLng? _currentPosition;

class _MapsState extends State<Maps> {
  late GoogleMapController _controller;
  static final CameraPosition _initalCameraPosition = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 15,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPosition = LatLng(_originLatitude, _originLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(36, 38), zoom: 15),
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        markers: _cretaeMarker(),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _getCurrentLocation();
        },
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position as LatLng?;
        print("bla bla$position");
      });
      return _currentPosition;
    }).catchError((e) {
      print(e);
    });
  }

  Set<Marker> _cretaeMarker() {
    return <Marker>[
      Marker(
          infoWindow: InfoWindow(title: "Konumum"),
          markerId: MarkerId("asdasd"),
          position: _initalCameraPosition.target,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
      Marker(
          infoWindow: InfoWindow(title: "Durak 1"),
          markerId: MarkerId("asdasd"),
          position: LatLng(40.2049104, 29.0078503),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
      Marker(
          infoWindow: InfoWindow(title: "Durak 2"),
          markerId: MarkerId("asdasdd"),
          position: LatLng(40.1845011, 29.1030112),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
      Marker(
          infoWindow: InfoWindow(title: "Durak 3"),
          markerId: MarkerId("asdsasdd"),
          position: LatLng(40.2111561, 29.0890572),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
    ].toSet();
  }
}
