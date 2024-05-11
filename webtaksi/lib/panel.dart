import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:webtaksi/services/webservices.dart';

class Panel extends StatefulWidget {
  var userdurak;

  Panel({Key? key, this.userdurak}) : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

TextEditingController durakadiController = TextEditingController();
TextEditingController durakadresController = TextEditingController();
TextEditingController enlemController = TextEditingController();
TextEditingController boylamController = TextEditingController();
TextEditingController menzilController = TextEditingController();
TextEditingController driver1telController = TextEditingController();
TextEditingController driver2telController = TextEditingController();
TextEditingController durakadController = TextEditingController();
TextEditingController plakaController = TextEditingController();
TextEditingController drivertelController = TextEditingController();
TextEditingController driverpassController = TextEditingController();
TextEditingController driverehliyetController = TextEditingController();
TextEditingController durakbilgiController = TextEditingController();
TextEditingController userdurakController = TextEditingController();
TextEditingController userpassController = TextEditingController();
TextEditingController usertelefonController = TextEditingController();
LatLng durakkonumu = LatLng(
    double.parse(enlemController.text),
    double.parse(
        boylamController.text)); //DURAK EKLEYEN KİŞİNİN EKLEDİĞİ SABİT KONUM
LatLng seciliDriverKonum =
    LatLng(0, 0); //Taksi hareketlerine göre değişecek olan konum.
late GoogleMapController _controller;
Location _location = Location();
List<String> durakList = [];
List taksiList = [];
List soforList = [];

List durakkonum = [
  LatLng(5, 1),
  LatLng(2, 32),
  LatLng(1, 76),
  LatLng(2, 1),
  LatLng(1, 1),
  LatLng(65, 76),
];
List<LatLng> driverkonum = [
  LatLng(51, 51),
  LatLng(49, 45),
  LatLng(45, 35),
  LatLng(78, 45)
];
List taksisiralama = [];
List duraksiralama = [];
LatLng secilenKonum = LatLng(0, 0);
LatLng secilenTaksi = LatLng(0, 0);

class _PanelState extends State<Panel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserSide();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: WebServices().getStatus(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          GeoPoint getdata = snapshot.data!.docs[0]["konum"];
          //Taksirequestte tek document olursa ve her taksi isteğinde yenilenirse datalar değişir
          Duraksira(LatLng(getdata.latitude, getdata.longitude), durakkonum);
          taksisira(driverkonum, 1, secilenKonum);
          return Scaffold(
            body: Container(
              child: Stack(children: [
                new GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0, 0), zoom: 10),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Container(
                  child: ListView(children: [
                    Card(child: Text("Gelen Müşteri İsteği")),
                    //DURAK
                    Card(
                      child: ExpansionTile(
                        onExpansionChanged: (e) {
                          //Your code
                        },
                        title: Text("Duraklar"),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: durakList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(durakList[index].toString());
                              }),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  showAlertDialogdurak(context);
                                },
                                child: Text("Durak Ekle")),
                          ),
                        ],
                      ),
                    ),
                    //TAKSİ
                    Card(
                      child: ExpansionTile(
                        onExpansionChanged: (e) {
                          //Your code
                        },
                        title: Text("Taksiler"),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: durakList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(taksiList[index].toString()),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      InkWell(
                                          onTap: (() {
                                            showAlertDialogtaksi(context);
                                          }),
                                          child: Icon(Icons.edit)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.delete),
                                    ]);
                              }),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  showAlertDialogtaksi(context);
                                },
                                child: Text("Taksi Ekle")),
                          ),
                        ],
                      ),
                    ),
                    //Şoför
                    Card(
                      child: ExpansionTile(
                        onExpansionChanged: (e) {
                          //Your code
                        },
                        title: Text("Şöförler"),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: durakList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(soforList[index].toString()),
                                      Icon(Icons.delete),
                                    ]);
                              }),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  showAlertDialogsofor(context);
                                },
                                child: Text("Şöför Ekle")),
                          ),
                        ],
                      ),
                    ),
                    Card(child: Text("Aidat Takibi")),
                    Card(child: Text("Bildirim Gönder")),
                    Card(
                        child: InkWell(
                            onTap: () {
                              showAlertDialogUser(context);
                            },
                            child: Text("Kullanıcı İşlemleri"))),
                    ElevatedButton(
                        onPressed: () {
                          //ÇIKIŞ YAP
                        },
                        child: Text("Çıkış"))
                  ]),
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.2,
                )
              ]),
            ),
          );
        });
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

  showAlertDialogdurak(BuildContext context) {
    // set up the button
    Widget updateButton = TextButton(
      child: Text("Güncelle"),
      onPressed: () {},
    );
    Widget addButton = TextButton(
      child: Text("Ekle"),
      onPressed: () {
        WebServices().durakEkle(
            durakadiController.text,
            durakadresController.text,
            durakkonumu,
            int.parse(menzilController.text));
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Duraklar"),
      content: Container(
        width: 500,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: durakadiController,
              decoration: InputDecoration(hintText: "Durak adı"),
            ),
            TextField(
              controller: durakadresController,
              decoration: InputDecoration(hintText: "Durak adresi"),
            ),
            Text("Durak konum Bilgisi Giriniz"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 70,
                  child: TextField(
                    controller: enlemController,
                    decoration: InputDecoration(hintText: "Enlem"),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  width: 100,
                  height: 70,
                  child: TextField(
                    controller: boylamController,
                    decoration: InputDecoration(hintText: "Boylam"),
                  ),
                ),
              ],
            ),
            TextField(
              controller: menzilController,
              decoration: InputDecoration(hintText: "Durak Menzili"),
            ),
          ],
        ),
      ),
      actions: [addButton, updateButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogtaksi(BuildContext context) {
    // set up the button
    Widget updateButton = TextButton(
      child: Text("Güncelle"),
      onPressed: () {},
    );
    Widget addButton = TextButton(
      child: Text("Ekle"),
      onPressed: () {
        WebServices().taksiEkle(
            driver1telController.text,
            driver2telController.text,
            durakadController.text,
            plakaController.text,
            seciliDriverKonum);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Taksiler"),
      content: Container(
        width: 500,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: plakaController,
              decoration: InputDecoration(hintText: "Taksi Plakası"),
            ),
            TextField(
              controller: durakadController,
              decoration: InputDecoration(hintText: "Durak adı"),
            ),
            TextField(
              controller: driver1telController,
              decoration: InputDecoration(hintText: "Şoför 1 Telefon"),
            ),
            TextField(
              controller: driver2telController,
              decoration: InputDecoration(hintText: "Şoför 2 Telefon"),
            ),
          ],
        ),
      ),
      actions: [
        addButton,
        updateButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogsofor(BuildContext context) {
    // set up the button
    Widget updateButton = TextButton(
      child: Text("Güncelle"),
      onPressed: () {},
    );
    Widget addButton = TextButton(
      child: Text("Ekle"),
      onPressed: () {
        WebServices().soforEkle(
          seciliDriverKonum,
          drivertelController.text,
          driverpassController.text,
          driverehliyetController.text,
          durakbilgiController.text,
        );
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Şöförler"),
      content: Container(
        width: 500,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: drivertelController,
              decoration: InputDecoration(hintText: "Telefon"),
            ),
            TextField(
              controller: driverpassController,
              decoration: InputDecoration(hintText: "Şifre"),
            ),
            TextField(
              controller: driverehliyetController,
              decoration: InputDecoration(hintText: "Ehliyet Bilgisi"),
            ),
            TextField(
              controller: durakbilgiController,
              decoration: InputDecoration(hintText: "Durak Bilgisi"),
            ),
          ],
        ),
      ),
      actions: [addButton, updateButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogUser(BuildContext context) {
    // set up the button
    Widget updateButton = TextButton(
      child: Text("Sil"),
      onPressed: () {},
    );
    Widget addButton = TextButton(
      child: Text("Yeni Kulllanıcı Ekle"),
      onPressed: () {
        WebServices().userEkle(
          userdurakController.text,
          userpassController.text,
          usertelefonController.text,
        );
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Duraklar"),
      content: Container(
        width: 500,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: usertelefonController,
              decoration: InputDecoration(hintText: "Kullanıcı Telefon No"),
            ),
            TextField(
              controller: userpassController,
              decoration: InputDecoration(hintText: "Kullanıcı Şifre"),
            ),
            TextField(
              controller: userdurakController,
              decoration:
                  InputDecoration(hintText: "Kullanıcının Sorumlu Durağı"),
            ),
          ],
        ),
      ),
      actions: [addButton, updateButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Duraksira(LatLng request, List durakkonum) {
    for (int i = 0; i < durakkonum.length; i++) {
      var a = Geolocator.distanceBetween(request.latitude, request.longitude,
          durakkonum[i].latitude, durakkonum[i].longitude);
      duraksiralama.add(a);
      if (a < duraksiralama.first) {
        print("gelen:${durakkonum[i]}");
        secilenKonum = durakkonum[i];
        return secilenKonum;
      }

      print("duraksıralama:${duraksiralama}");
      print("mesafe:${a}");
    }
  }

  taksisira(List<LatLng> driverkonum, int menzil, LatLng secilenKonum) {
    for (int i = 0; i <= driverkonum.length; i++) {
      var b = Geolocator.distanceBetween(
        secilenKonum.latitude,
        secilenKonum.longitude,
        driverkonum[i].latitude,
        driverkonum[i].longitude,
      );
      taksisiralama.add(b);
      if (b < taksisiralama.first) {
        secilenTaksi = driverkonum[i];
        print("secTaksi${secilenTaksi}");
        return secilenTaksi;
      }
    }
  }

  getUserSide() {
    if ("a" == WebServices().getdata()) {
    } else {}
  }
}

//Son aşama: taksi requestten istek anlık okunup ilgili taksicinin konumu belirlenebiliyor.driver tarafında dinleme yapma işi kaldı.
