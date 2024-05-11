import 'package:cabrent/screens/home.dart';
import 'package:cabrent/services/authservice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cabrent/widgets/textfield.dart';

import '../localekeys.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController adController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(58.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
              ),
              textfield(
                  helper: LocaleKeys.reg_email.tr(),
                  controller: emailController),
              textfield(
                  helper: LocaleKeys.reg_sifre.tr(),
                  controller: passwordController),
              textfield(
                  helper: LocaleKeys.reg_ad.tr(), controller: adController),
              textfield(
                helper: LocaleKeys.reg_telefon.tr(),
                controller: telefonController,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 50), primary: Colors.black),
                  onPressed: (() {
                    AuthService()
                        .registerUser(
                            adController.text,
                            telefonController.text,
                            emailController.text,
                            passwordController.text,
                            context)
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        phoneGet: telefonController.text,
                                        nameGet: adController.text,
                                      )),
                            ));
                  }),
                  child: Text(
                    LocaleKeys.reg_buton.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
