import 'package:cabrent/screens/register.dart';
import 'package:cabrent/widgets/phonereg.dart';
import 'package:cabrent/widgets/textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localekeys.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(58.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  LocaleKeys.home_logbaslik.tr(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 118, 142, 150),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      fontFamily: "lato"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  LocaleKeys.home_altbaslik.tr(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 143, 0, 161),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: "lato"),
                ),
                SizedBox(
                  height: 20,
                ),
                textfield(
                    helper: LocaleKeys.home_telefon.tr(),
                    controller: phoneController),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  child: Text(
                    LocaleKeys.home_uye.tr(),
                    style: TextStyle(
                        color: Color.fromARGB(255, 123, 23, 136),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(300, 50), primary: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyPhoneNumberScreen(
                                phoneNumber: phoneController.text)),
                      );
                    },
                    child: Text(
                      LocaleKeys.home_logbuton.tr(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
