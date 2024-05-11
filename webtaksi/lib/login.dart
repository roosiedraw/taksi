import 'package:flutter/material.dart';
import 'package:webtaksi/panel.dart';
import 'package:webtaksi/services/webservices.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController telefonController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: telefonController,
              decoration: InputDecoration(hintText: "Durak adı"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Durak adı"),
            ),
            ElevatedButton(
                onPressed: (() {
                  loginControl();
                }),
                child: Text("Giriş"))
          ],
        ),
      ),
    );
  }

  loginControl() async {
    List userSaved = await WebServices().getauth() as List;

    for (int i = 0; i < userSaved.length; i++) {
      if (telefonController.text == userSaved[i]["telefon"].toString()) {
        print("BAŞARILI");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Panel(
                      userdurak: userSaved[i]["durak"],
                    )));
        break;
      } else {
        print("BAŞARISIZ");
      }
    }
  }
}
