import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class textfield extends StatelessWidget {
  textfield({Key? key, required this.helper, required this.controller})
      : super(key: key);
  String helper;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255), width: 2),
            ),
            labelText: helper,
            labelStyle: new TextStyle(color: const Color(0xFF424242))));
  }
}
