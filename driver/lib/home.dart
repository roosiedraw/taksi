import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/services/driverServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  String driverdurak = "";
  Home({Key? key, required this.driverdurak}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final CollectionReference collectiontalep =
    FirebaseFirestore.instance.collection("Taksirequest");
bool _switchValue = true;
Color _colorAktif = Colors.grey;
Color _colorGreen = Colors.green;
Location _location = Location();
GeoPoint geoPoint = GeoPoint(3, 5);

LatLng kon = LatLng(0, 0);
bool isvisible = false;

class _HomeState extends State<Home> {
  late GoogleMapController _controller;
  bool pressed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(geoPoint.latitude.toString()),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              //MAP
              Expanded(
                  flex: 3,
                  child: Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    geoPoint.latitude, geoPoint.longitude)),
                            mapType: MapType.normal,
                            markers: createMarker(
                              LatLng(geoPoint.latitude, geoPoint.longitude),
                            ),
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                          ),
                        ],
                      ))),
              //Taksi İstek kart
              Visibility(
                visible: isvisible,
                child: Expanded(
                    flex: 1,
                    child: Container(
                      color: Color.fromARGB(255, 214, 182, 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(geoPoint.latitude.toString()),
                              SizedBox(
                                width: 5,
                              ),
                              Text(geoPoint.longitude.toString()),
                            ],
                          ),
                          Divider(thickness: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(100, 60),
                                      primary: Colors.green),
                                  onPressed: () {
                                    //konumu haritada göster
                                    changeStatustrue();
                                    setState(() {
                                      geoPoint = geoPoint;
                                    });
                                  },
                                  child: Text(
                                    "Kabul Et",
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(100, 60),
                                      primary: Colors.red),
                                  onPressed: () {
                                    changeStatusfalse();
                                  },
                                  child: Text(
                                    "Reddet",
                                  ))
                            ],
                          )
                        ],
                      ),
                    )),
              ),
              //Alt ekran
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  pressed
                                      ? Container(
                                          width: 120,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Taksi Aktif",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                        )
                                      : Container(
                                          width: 120,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.red, width: 2),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Taksi Pasif",
                                              style: pressed
                                                  ? TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700)
                                                  : TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                  CupertinoSwitch(
                                    value: _switchValue,
                                    onChanged: (value) {
                                      setState(() {
                                        pressed = !pressed;
                                        _switchValue = value;
                                      });
                                      pressed ? talep() : Text("data");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Durak Sıranız",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "2",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.amber),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _location.onLocationChanged.listen((l) {
      /*_controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );*/
    });
  }

  talep() async {
    List TalepListesi = await DriverService().getTalep();

    for (int i = 0; i < TalepListesi.length; i++) {
      if (TalepListesi[i]["durak"] == widget.driverdurak.toString()) {
        print("TALEP GELDİ");
        geoPoint = TalepListesi[i]["konum"] as GeoPoint;
        setState(() {
          isvisible = true;
        });
        return;
      } else {
        setState(() {
          isvisible = false;
        });

        print("TALEP GELMEDİ");
      }
    }
    return Text(geoPoint.latitude.toString());
  }

  showAlertDialog(BuildContext context, GeoPoint geoPoint) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Taksi Talebi Geldi"),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Konum:"),
                Text(geoPoint.latitude.toString()),
                Text(geoPoint.longitude.toString())
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 60), primary: Colors.green),
                    onPressed: () {
                      Navigator.pop(context, geoPoint);
                      //konumu haritada göster
                      changeStatustrue();
                      setState(() {
                        geoPoint = geoPoint;
                      });
                    },
                    child: Text(
                      "Kabul Et",
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 60), primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);

                      return changeStatusfalse();
                    },
                    child: Text(
                      "Reddet",
                    ))
              ],
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  changeStatusfalse() {
    DriverService().updateReverseData();
  }

  changeStatustrue() {
    DriverService().updateData();
  }

  Set<Marker> createMarker(LatLng c) {
    return <Marker>{
      Marker(
          infoWindow: InfoWindow(title: "Müşteri"),
          markerId: MarkerId("asdasd"),
          position: c,
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
    };
  }
}
