import 'dart:convert';

import 'package:control_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String startValidator(String val) {
    return int.tryParse(val) != null
        ? int.tryParse(val) > 0
            ? endVal.toInt() < startVal.toInt()
                ? 'Minimun temperature should be less Maximum'
                : null
            : 'Minimun temperature should be more than 0 C°'
        : 'Minimun temperature should be more than 0 C°';
  }

  String endValidator(String val) {
    return int.tryParse(val) != null
        ? int.tryParse(val) < 75
            ? endVal.toInt() < startVal.toInt()
                ? 'Minimun temperature should be less Maximum'
                : null
            : 'Minimun temperature should be less than 75 C°'
        : 'Minimun temperature should be less than 75 C°';
  }

  bool edit = false;
  int startVal;
  int endVal;
  final formGlobalKey = GlobalKey<FormState>();

  void _sendMessage(String text, connection) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.blue[900],
                      width: MediaQuery.of(context).size.width * 0.012,
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Text(
                      'Sample Reference Temperature',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Card(
                  shape: new CircleBorder(
                      side: BorderSide(color: Colors.grey[300])),
                  color: edit ? Colors.greenAccent[400] : null,
                  child: Consumer<Myprovider>(
                    builder: (context, value, child) => IconButton(
                        onPressed: () {
                          if (edit) {
                            if (formGlobalKey.currentState.validate()) {
                              formGlobalKey.currentState.save();
                              value.start = startVal.toInt();
                              value.end = startVal.toInt();
                              print(value.start);

                              _sendMessage(
                                  startVal.toString(), value.connection);
                              setState(() {
                                edit = false;
                              });
                            }
                          } else {
                            setState(() {
                              edit = true;
                            });
                          }
                        },
                        icon: !edit
                            ? Icon(Icons.edit_rounded)
                            : Icon(Icons.done_outline)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: startValidator,
              onSaved: (String val) {
                startVal = int.parse(val);
              },
              onChanged: (String val) {
                startVal = int.parse(val);
              },
              enabled: edit,
              style:
                  TextStyle(color: Colors.black, decorationColor: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.blue[900], decorationColor: Colors.white),
                hintStyle: TextStyle(
                    color: Colors.blue[900], decorationColor: Colors.white),
                labelText: 'Start C°',
                hintText: 'Start C°',
                prefixIcon:
                    Icon(Icons.arrow_forward_rounded, color: Colors.blue[900]),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900], width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: endValidator,
              onSaved: (String val) {
                endVal = int.parse(val);
              },
              onChanged: (String val) {
                endVal = int.parse(val);
              },
              enabled: edit,
              style:
                  TextStyle(color: Colors.black, decorationColor: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.blue[900], decorationColor: Colors.white),
                hintStyle: TextStyle(
                    color: Colors.blue[900], decorationColor: Colors.white),
                labelText: 'End C°',
                hintText: 'End C°',
                prefixIcon:
                    Icon(Icons.arrow_back_rounded, color: Colors.blue[900]),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900], width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
