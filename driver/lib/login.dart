import 'package:driver/services/driverServices.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController tcController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/taxi.png",
                width: 256,
                height: 256,
              ),
              TextField(
                  style: TextStyle(color: Colors.white),
                  controller: tcController,
                  decoration: new InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 226, 222, 0), width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 2),
                      ),
                      labelText: "TC Kimlik Numaranız",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)))),
              TextField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  decoration: new InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 206, 0), width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 2),
                      ),
                      labelText: "Şifreniz",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)))),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.amber,
                  ),
                  onPressed: () {
                    auth();
                  },
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  auth() async {
    List driverSaved = await DriverService().getData() as List;

    for (int i = 0; i < driverSaved.length; i++) {
      if (tcController.text == driverSaved[i]["tc"].toString()) {
        print("BAŞARILI");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      driverdurak: driverSaved[i]["durak"],
                    )));
        break;
      } else {
        print("BAŞARISIZ");
      }
    }
  }
}
