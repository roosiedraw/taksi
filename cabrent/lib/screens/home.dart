import 'dart:async';
import 'dart:math';
import 'package:cabrent/screens/login.dart';
import 'package:cabrent/services/listenservice.dart';
import 'package:cabrent/services/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../localekeys.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want

class Home extends StatefulWidget {
  var phoneGet;
  var nameGet;

  Home({Key? key, this.phoneGet, this.nameGet}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

LatLng latLng = LatLng(0, 0); //Anlık kullanıcı konumu

Location _location = Location(); //Location tanımlaması
bool isLoggedIn = false; //Autologin durumu
String name = ''; //AutoLogin ismiS
bool taksiBulundu = true;
bool taksiResponse = false;
late GoogleMapController _controller;

var durak1kon = LatLng(40.2049104, 29.0078503);
var durak2kon = LatLng(40.1845011, 29.1030112);
var durak3kon = LatLng(40.2111561, 29.0890572);
List<LatLng> DurakKonum = [
  durak1kon,
  durak2kon,
  durak3kon,
];

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getUserLocation();
    loginUser("blabla");
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.phoneGet.toString()),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.amber),
                child: Center(
                    child: Icon(
                  Icons.local_taxi,
                  size: 60,
                ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  child: ListTile(
                      title: Text(
                        LocaleKeys.home_kampanya.tr(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: (() {}),
                child: Card(
                  child: ListTile(
                      title: Text(
                        LocaleKeys.home_durak.tr(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: (() {}),
                child: Card(
                  child: ListTile(
                      title: Text(
                        LocaleKeys.home_oneri.tr(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: (() {}),
                child: Card(
                  child: ListTile(
                      title: Text(
                        LocaleKeys.home_hak.tr(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: InkWell(
                  child: Text("Çıkış Yap"),
                  onTap: () {
                    logout();
                  },
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: new GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0, 0), zoom: 10),
                  markers: createMarker(),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                          left: 15,
                        ),
                        child: Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.home_baslik.tr(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //TAKSİ ÇAĞRI BUTONUDUR.BUNA BASINCA KULLANICININ KONUM BİLGİSİNİ VE TAKSİ İSTEĞİNİ(bool olarak) VERİTABANINA YAZAR.
                    //İLK GİRİŞTE EĞER ÜYE DEĞİLSE ÜYELİK İÇİN KAYIT OL VEYA GİRİŞ YAP A YÖNLENDİRİR
                    ElevatedButton(
                      onPressed: () async {
                        isLoggedIn
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              )
                            : showAlertDialog(context);
                        RequestService().addUser(
                            LatLng(latLng.latitude, latLng.longitude),
                            widget.phoneGet ?? "bos",
                            taksiBulundu = false);
                      },
                      child: Text(
                        LocaleKeys.home_buton.tr(),
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          fixedSize: Size(300, 60),
                          primary: Colors.amber),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            context.setLocale(AppConstant.EN_LOCALE);
                          },
                          child: const Text("ENG"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            context.setLocale(AppConstant.TR_LOCALE);
                          },
                          child: const Text("TR"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//*******AUTOLOGİN FONKSİYONLARI *********/
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('username');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        name = userId;
      });
      return;
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', "");

    setState(() {
      name = '';
      isLoggedIn = false;
    });
  }

  Future<Null> loginUser(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', widget.phoneGet.toString());

    setState(() {
      name = widget.phoneGet.toString();
      isLoggedIn = true;
    });

    widget.phoneGet.clear();
  }

  /* durakMesafe() {
    var durak1 = calculateDistance(
        DurakKonum[0].latitude,
        DurakKonum[0].longitude,
        _currentPosition.latitude,
        _currentPosition.longitude);
    var durak2 = calculateDistance(
        DurakKonum[1].latitude,
        DurakKonum[1].longitude,
        _currentPosition.latitude,
        _currentPosition.longitude);
    var durak3 = calculateDistance(
        DurakKonum[2].latitude,
        DurakKonum[2].longitude,
        _currentPosition.latitude,
        _currentPosition.longitude);

    if (durak1 > durak2) {
      userkonum = "durak1kon";
    } else if (durak2 < durak3) {
      userkonum = "durak2kon";
    } else {
      userkonum = "durak3kon";
    }
    /*var f = [
      {"durak1": durak1},
      {"durak2": durak2},
      {"durak3": durak3}
    ];
    f.sort;

    print(f[0]);*/
    return userkonum;
  }
*/
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Taksi Aranıyor"),
      content: taksiResponse == taksiBulundu
          ? Container(
              height: 150,
              width: 50,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                  StreamBuilder(
                      stream: listenService().getStatus(),
                      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                        var items = snapshot.data?.docs;
                        return Text(items![0]["taksibulundu"].toString());
                      }),
                ],
              ))
          : Container(
              width: 500,
              height: 300,
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("Taksi Bulundu!!!"),
                      subtitle: Text(
                        "Taksiniz Yola Çıktı",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GiveStarReviews(
                    starData: [
                      GiveStarData(
                          text: 'Puanla',
                          onChanged: (rate) {
                            _showToast(context, rate.toString());
                          }),
                    ],
                  ),
                  //Streambuilder ile dinleme yapılır taksibulundu=true bilgisi gelirse taksi gelir
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

  Set<Marker> createMarker() {
    return <Marker>[
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

  void _showToast(BuildContext context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(txt),
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.best);
  }

  getUserLocation() async {
    var currentLocation = await locateUser();
    setState(() {
      latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    print(latLng);
  }
}
